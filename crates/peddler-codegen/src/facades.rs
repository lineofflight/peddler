//! Thin public Rust/Ruby facades derived from operation metadata.
use crate::{
    GenerationError,
    clients::{Operation, Parameter, pascal, rust_type},
    docs, format_source, known_values,
    manifest::ModelSpec,
    pagination::{self, Resolved},
};
use serde_json::{Value, json};
use std::{collections::BTreeMap, fmt::Write};

fn field_type(p: &Parameter) -> Result<String, GenerationError> {
    let ty = if p.location == "body" {
        "B".into()
    } else {
        rust_type(p)?
    };
    Ok(if p.required {
        ty
    } else {
        format!("Option<{ty}>")
    })
}
fn params_name(op: &Operation) -> String {
    format!("{}Params", pascal(&op.name))
}
/// An API module's doc, as its Ruby class has it: the spec's title, its description
/// and a link to the spec.
pub(crate) fn module_doc(api: &ModelSpec, info: &Value) -> String {
    let text = |key: &str| info[key].as_str().unwrap_or_default().trim();
    let link = format!(
        "<https://github.com/amzn/selling-partner-api-models/blob/main/models/{}>",
        api.source
    );
    let description = docs::links(text("description"));
    let parts = [text("title"), description.trim(), &link];
    let parts: Vec<&str> = parts.into_iter().filter(|part| !part.is_empty()).collect();
    doc(&parts.join("\n\n"))
}
/// Text as a doc attribute. A spec is data: the attribute holds it as a string, and
/// `format_source` writes it as a line comment for each of its lines.
fn doc(text: &str) -> String {
    format!("#[doc = {text:?}]\n")
}
/// A parameter's doc: its description, then the values it is known to take, as a
/// model field's doc lists them. Empty when the spec says nothing of it.
fn field_doc(p: &Parameter) -> String {
    let description = p.description.as_deref().unwrap_or_default();
    let text = match known_values::sentence(description, &p.known) {
        Some(sentence) => format!("{description}\n\n{sentence}"),
        None => description.to_owned(),
    };
    match text.trim() {
        "" => String::new(),
        text => doc(text),
    }
}
/// How the type of a body appears in an operation's items. Empty when it has none.
struct BodyType {
    /// On the parameter struct
    declared: &'static str,
    /// Wherever the struct is named
    named: &'static str,
    /// On a function that sends it
    bound: &'static str,
}
impl BodyType {
    fn of(op: &Operation) -> Self {
        if op.body().is_some() {
            Self {
                declared: "<B = serde_json::Value>",
                named: "<B>",
                bound: "B: serde::Serialize",
            }
        } else {
            Self {
                declared: "",
                named: "",
                bound: "",
            }
        }
    }
}
/// What an operation's function returns.
enum Returns {
    /// `Response`: no success status has a model.
    Raw,
    /// `TypedResponse` of the one model every success status has.
    Typed(String),
    /// A struct of this name, with a decoder for each status that has a model.
    ByStatus(String),
}
impl Returns {
    fn of(op: &Operation) -> Self {
        let models: std::collections::BTreeSet<_> = op.successes.iter().map(|(_, m)| m).collect();
        if models.len() == 1
            && let Some(Some(model)) = models.first()
        {
            Self::Typed(model.clone())
        } else if models.iter().any(|m| m.is_some()) {
            Self::ByStatus(format!("{}Response", pascal(&op.name)))
        } else {
            Self::Raw
        }
    }
}
pub fn rust(operations: &[Operation], pagination: &[&Resolved]) -> Result<String, GenerationError> {
    let mut source = String::from(
        "use crate::{Client, Error, Request, Response};\nuse crate::operation::{self, DecodeError, TypedResponse};\n",
    );
    for op in operations {
        let mapped = pagination.iter().find(|r| r.name == op.name);
        params_struct(&mut source, op, mapped.is_some())?;
        call(&mut source, op, mapped.is_some())?;
        if let Some(mapped) = mapped {
            pages(&mut source, op, mapped)?;
        }
    }
    // Some operations have no typed decoder or no parameter at all.
    Ok(format!(
        "#![allow(unused_imports, unused_variables, clippy::too_many_arguments)]\n{}",
        format_source(&source)?
    ))
}
/// An operation's parameter struct, with its defaults and its constructor.
fn params_struct(source: &mut String, op: &Operation, paged: bool) -> Result<(), GenerationError> {
    let params = params_name(op);
    let body = BodyType::of(op);
    // Each field with its type and, when the spec gives an optional one a default,
    // the function that returns it.
    let mut fields = Vec::new();
    for p in &op.parameters {
        let default = match p.schema.get("default") {
            Some(default) if !p.required => Some((
                format!("{}_{}_default", op.name, p.name),
                serde_json::to_string(default)?,
            )),
            _ => None,
        };
        fields.push((p, field_type(p)?, default));
    }
    for (_, ty, default) in &fields {
        if let Some((function, value)) = default {
            writeln!(source,"fn {function}() -> {ty} {{ Some(serde_json::from_str({value:?}).expect(\"validated schema default\")) }}").unwrap();
        }
    }
    let takers = if paged {
        format!("[`{0}`] and [`{0}_pages`]", op.name)
    } else {
        format!("[`{}`]", op.name)
    };
    source.push_str(&doc(&format!("The parameters of {takers}.")));
    writeln!(source,"#[derive(Clone, Debug, serde::Deserialize, serde::Serialize)]\n#[serde(deny_unknown_fields)]\npub struct {params}{} {{", body.declared).unwrap();
    for (p, ty, default) in &fields {
        source.push_str(&field_doc(p));
        if let Some((function, _)) = default {
            writeln!(source, "#[serde(default = {function:?})]").unwrap()
        }
        writeln!(source, "pub {}: {ty},", p.name).unwrap();
    }
    source.push_str("}\n");
    let required = fields
        .iter()
        .filter(|(p, ..)| p.required)
        .map(|(p, ty, _)| format!("{}: {ty}", p.name))
        .collect::<Vec<_>>()
        .join(", ");
    let new = if fields.iter().all(|(p, ..)| p.required) {
        "Takes the required parameters."
    } else {
        "Takes the required parameters. Each optional one is `None`, or its default in the spec."
    };
    writeln!(
        source,
        "impl{} {params}{} {{ {} pub fn new({required}) -> Self {{ Self {{",
        body.named,
        body.named,
        doc(new)
    )
    .unwrap();
    for (p, _, default) in &fields {
        match default {
            _ if p.required => writeln!(source, "{},", p.name),
            Some((function, _)) => writeln!(source, "{}: {function}(),", p.name),
            None => writeln!(source, "{}: None,", p.name),
        }
        .unwrap();
    }
    source.push_str("} } }\n");
    if op.parameters.iter().all(|p| !p.required) {
        writeln!(
            source,
            "impl{} Default for {params}{} {{ fn default() -> Self {{ Self::new() }} }}",
            body.named, body.named
        )
        .unwrap();
    }
    Ok(())
}
/// The function that sends an operation, after the response struct it returns, if
/// it has its own. Its doc is the operation's, as its Ruby method has it.
fn call(source: &mut String, op: &Operation, paged: bool) -> Result<(), GenerationError> {
    let body = BodyType::of(op);
    let (returned, wrapped) = match Returns::of(op) {
        Returns::Raw => ("Response".to_owned(), "raw".to_owned()),
        Returns::Typed(model) => (
            format!("TypedResponse<{model}>"),
            "TypedResponse::new(raw)".to_owned(),
        ),
        Returns::ByStatus(name) => {
            write!(
                source,
                "{}#[derive(Debug)] pub struct {name} {{ {} pub raw: Response }}\nimpl {name} {{ {} pub fn into_raw(self)->Response {{self.raw}}",
                doc(&format!("The response of [`{}`]. Nothing is parsed until asked.", op.name)),
                doc("The response as it arrived, whatever its status."),
                doc("The response as it arrived."),
            )
            .unwrap();
            for (status, model) in &op.successes {
                if let Some(model) = model {
                    let text = format!("Parses the body into the model of a {status} response.");
                    writeln!(source,"{}pub fn json_{status}(&self)->Result<{model},DecodeError> {{ crate::operation::decode_status(&self.raw,{status}) }}", doc(&text)).unwrap()
                }
            }
            source.push_str("}\n");
            (name.clone(), format!("{name} {{raw}}"))
        }
    };
    let mut text = docs::description(&op.description);
    if paged {
        write!(text, "\n\nIts pages: [`{}_pages`].", op.name).unwrap();
    }
    if !text.trim().is_empty() {
        source.push_str(&doc(text.trim()));
    }
    writeln!(
        source,
        "pub async fn {}<{}>(client:&Client, params:{}{})->Result<{returned},Error> {{",
        op.name,
        body.bound,
        params_name(op),
        body.named
    )
    .unwrap();
    request(source, op)?;
    writeln!(source, "Ok({wrapped})\n}}").unwrap();
    Ok(())
}
/// The page stream of a mapped operation, and its continuation operation if the
/// mapping asks for one.
fn pages(source: &mut String, op: &Operation, mapped: &Resolved) -> Result<(), GenerationError> {
    let body = BodyType::of(op);
    source.push_str(&doc(&format!("Each page of [`{}`].", op.name)));
    writeln!(source,"pub fn {}_pages<'a, {}>(client:&'a Client, params:{}{})->crate::pagination::PageStream<'a> {{ crate::pagination::pages(client, {}, &params) }}",op.name,body.bound,params_name(op),body.named,pagination::rust_expression(mapped)).unwrap();
    if mapped.mapping.continuation.adapter {
        adapter(source, op, mapped)?;
    }
    Ok(())
}
/// Sends an operation's request, built from `params`, and binds the response to `raw`.
fn request(source: &mut String, op: &Operation) -> Result<(), GenerationError> {
    let given = |p: &Parameter| {
        if p.required {
            format!("Some(&params.{})", p.name)
        } else {
            format!("params.{}.as_ref()", p.name)
        }
    };
    let add = |list: &str, add: &str, p: &Parameter| {
        format!(
            "operation::{add}(&mut {list}, {:?}, {});\n",
            p.wire_name,
            given(p)
        )
    };
    let mut queries: Vec<&Parameter> = op
        .parameters
        .iter()
        .filter(|p| p.location == "query")
        .collect();
    let arrays: Vec<&Parameter> = queries
        .iter()
        .copied()
        .filter(|p| p.schema["type"] == "array")
        .collect();
    // The order requests have always had: values by name, then empty arrays as declared.
    queries.sort_by(|a, b| a.wire_name.cmp(&b.wire_name));
    let values = queries.iter().map(|p| {
        let kind = match (p.schema["type"] == "array", p.csv) {
            (false, _) => "pair",
            (true, true) => "csv",
            (true, false) => "repeated",
        };
        add("query", kind, p)
    });
    let query: String = values
        .chain(arrays.iter().map(|p| add("query", "empty", p)))
        .collect();
    let headers: String = op
        .parameters
        .iter()
        .filter(|p| p.location == "header")
        .map(|p| add("headers", "pair", p))
        .collect();
    let mut fields = Vec::new();
    for (list, lines) in [("query", query), ("headers", headers)] {
        if lines.is_empty() {
            fields.push(format!("{list}: Vec::new()"));
        } else {
            writeln!(source, "let mut {list} = Vec::new();\n{lines}").unwrap();
            fields.push(list.to_owned());
        }
    }
    let body = match op.body() {
        Some(body) if body.required => "Some(operation::json(&params.body)?)",
        Some(_) => "params.body.as_ref().map(operation::json).transpose()?",
        None => "None",
    };
    writeln!(
        source,
        "let raw = client.execute_json(Request {{ method: {:?}.into(), path: {}, {}, body: {body} }}, {}).await?;",
        op.method,
        path(op)?,
        fields.join(", "),
        rate(op)
    )
    .unwrap();
    Ok(())
}
/// An operation's documented rate, as the client takes it for the wait after a 429.
fn rate(op: &Operation) -> String {
    format!("{:?}", op.rate)
}
/// The expression for an operation's path, with each argument as one escaped segment.
fn path(op: &Operation) -> Result<String, GenerationError> {
    let mut parts = Vec::new();
    let mut arguments = 0;
    let mut rest = op.path.as_str();
    while let Some((before, after)) = rest.split_once('{') {
        let (name, tail) = after
            .split_once('}')
            .ok_or_else(|| GenerationError(format!("{}: malformed path", op.name)))?;
        let p = op
            .parameters
            .iter()
            .find(|p| p.location == "path" && p.wire_name == name)
            .ok_or_else(|| GenerationError(format!("{}: unknown path parameter", op.name)))?;
        let segment = if tail.is_empty() {
            "last_segment"
        } else {
            "segment"
        };
        parts.push(format!("{before:?}"));
        parts.push(format!("&operation::{segment}(&params.{})?", p.name));
        arguments += 1;
        rest = tail;
    }
    if arguments
        != op
            .parameters
            .iter()
            .filter(|p| p.location == "path")
            .count()
    {
        return Err(GenerationError(format!(
            "{}: path parameter missing from the path",
            op.name
        )));
    }
    Ok(if arguments == 0 {
        format!("{rest:?}.into()")
    } else {
        if !rest.is_empty() {
            parts.push(format!("{rest:?}"));
        }
        format!("[{}].concat()", parts.join(", "))
    })
}
/// A private continuation operation for APIs whose token replaces every other
/// parameter: it sends the token and path parameters only, so the initial
/// request's required filters are not demanded again. It runs through the same
/// client, so the token, retries, rate and timeout are unchanged.
fn adapter(source: &mut String, op: &Operation, mapped: &Resolved) -> Result<(), GenerationError> {
    let token = &mapped.mapping.input[1..];
    let kept: Vec<&Parameter> = op
        .parameters
        .iter()
        .filter(|p| p.location == "path" || p.name == token)
        .collect();
    if kept.iter().any(|p| p.schema["type"] != "string") {
        return Err(GenerationError(format!(
            "{}: adapter arguments must be strings",
            op.name
        )));
    }
    let strukt = format!("{}ContinueParams", pascal(&op.name));
    writeln!(
        source,
        "#[derive(serde::Deserialize)]\n#[serde(deny_unknown_fields)]\npub(crate) struct {strukt} {{"
    )
    .unwrap();
    for p in &kept {
        writeln!(source, "pub {}: String,", p.name).unwrap();
    }
    source.push_str("}\n");
    let wire = &op
        .parameters
        .iter()
        .find(|p| p.name == token)
        .expect("resolved token")
        .wire_name;
    writeln!(
        source,
        "pub(crate) async fn {}_continue(client:&Client, params:{strukt})->Result<Response,Error> {{\nclient.execute_json(Request {{ method: {:?}.into(), path: {}, query: vec![({wire:?}.into(), params.{token})], headers: Vec::new(), body: None }}, {}).await\n}}",
        op.name,
        op.method,
        path(op)?,
        rate(op)
    )
    .unwrap();
    Ok(())
}
pub(crate) fn pagination_table(resolved: &[Resolved]) -> Result<String, GenerationError> {
    let arms = resolved
        .iter()
        .map(|r| format!("{:?} => {},", r.key, pagination::rust_expression(r)))
        .collect::<String>();
    format_source(&format!(
        "/// The explicit pagination mapping of an operation, from `pagination.json`.\npub fn mapping(operation: &str) -> Option<crate::pagination::Pagination> {{ Some(match operation {{ {arms} _ => return None }}) }}\n"
    ))
}
pub(crate) fn dispatch(
    clients: &[(&ModelSpec, Vec<Operation>)],
    resolved: &[Resolved],
) -> Result<String, GenerationError> {
    let mut source = String::from(
        "type OperationFuture<'a> = std::pin::Pin<Box<dyn std::future::Future<Output=Result<crate::Response,crate::Error>> + Send + 'a>>;\ntype Handler = for<'a> fn(&'a crate::Client, &'a str)->OperationFuture<'a>;\n/// Sends an operation by its key, such as `orders_v0.get_orders`, with its parameters as JSON. An unknown key, or parameters that don't parse, is a [`crate::Error::InvalidRequest`]. The Ruby extension calls it.\npub fn execute<'a>(client:&'a crate::Client, operation:&str, arguments:&'a str)->OperationFuture<'a> { let handler: Handler = match operation {\n",
    );
    for (api, operations) in clients {
        for op in operations {
            writeln!(
                source,
                "{:?} => {}_{},",
                format!("{}.{}", api.module, op.name),
                api.module,
                op.name
            )
            .unwrap();
        }
    }
    for r in resolved {
        if let Some(key) = r.adapter_key() {
            writeln!(source, "{key:?} => {}_{}_continue,", r.module, r.name).unwrap();
        }
    }
    source.push_str("_=>return Box::pin(std::future::ready(Err(crate::Error::InvalidRequest))), }; handler(client,arguments) }\n");
    for r in resolved.iter().filter(|r| r.adapter_key().is_some()) {
        writeln!(source,"fn {m}_{n}_continue<'a>(client:&'a crate::Client,arguments:&'a str)->OperationFuture<'a> {{ Box::pin(async move {{ let params:crate::apis::{m}::{p}ContinueParams=serde_json::from_str(arguments).map_err(|_|crate::Error::InvalidRequest)?; crate::apis::{m}::{n}_continue(client,params).await }}) }}",m=r.module,n=r.name,p=pascal(&r.name)).unwrap();
    }
    for (api, operations) in clients {
        for op in operations {
            let params = params_name(op);
            let annotation = if op.body().is_some() {
                format!("crate::apis::{}::{params}<serde_json::Value>", api.module)
            } else {
                format!("crate::apis::{}::{params}", api.module)
            };
            let expression = if matches!(Returns::of(op), Returns::Raw) {
                format!(
                    "crate::apis::{}::{}(client,params).await",
                    api.module, op.name
                )
            } else {
                format!(
                    "Ok(crate::apis::{}::{}(client,params).await?.into_raw())",
                    api.module, op.name
                )
            };
            writeln!(source,"fn {}_{}<'a>(client:&'a crate::Client,arguments:&'a str)->OperationFuture<'a> {{ Box::pin(async move {{ let params:{annotation}=serde_json::from_str(arguments).map_err(|_|crate::Error::InvalidRequest)?; {expression} }}) }}",api.module,op.name).unwrap();
        }
    }
    format_source(&source)
}
/// The method of `Peddler::Native::Arguments` that an argument goes through.
fn ruby_coercion(p: &Parameter) -> &'static str {
    match p.location.as_str() {
        "body" => return "body",
        "path" => return "segment",
        _ => {}
    }
    match p.schema["type"].as_str() {
        Some("array") => "array",
        Some("boolean") => "boolean",
        Some("integer") => "integer",
        Some("number") => "number",
        _ => "string",
    }
}
/// A parameter's default as a Ruby literal. A spec is data, so only what a literal
/// holds without running anything is written: a number, `true`, a String and an Array
/// of them.
fn ruby_default(value: &Value) -> Result<String, GenerationError> {
    Ok(match value {
        // v5 left a default of false out, so Amazon's own default applied.
        Value::Null | Value::Bool(false) => "nil".into(),
        Value::Bool(true) | Value::Number(_) => value.to_string(),
        // JSON's quoting is Ruby's too, but for `#`, which would interpolate.
        Value::String(_) => value.to_string().replace('#', "\\#"),
        Value::Array(values) => {
            let items = values.iter().map(ruby_default);
            format!("[{}]", items.collect::<Result<Vec<_>, _>>()?.join(", "))
        }
        Value::Object(_) => {
            return Err(GenerationError(
                "unsupported default: an object can't be a Ruby literal".into(),
            ));
        }
    })
}
/// The words Peddler writes in capitals, as `lib/peddler/acronyms.rb` has them for the
/// models. A test in Ruby holds this list to that file, entry for entry.
const ACRONYMS: [(&str, &str); 16] = [
    ("Api", "API"),
    ("Apis", "APIs"),
    ("Asin", "ASIN"),
    ("B2b", "B2B"),
    ("Cgst", "CGST"),
    ("Cod", "COD"),
    ("Ebt", "EBT"),
    ("Fba", "FBA"),
    ("Igst", "IGST"),
    ("Lwa", "LWA"),
    ("Safet", "SAFET"),
    ("Sgst", "SGST"),
    ("Sku", "SKU"),
    ("Tds", "TDS"),
    ("Url", "URL"),
    ("Urls", "URLs"),
];
/// The name of an API's class in Ruby, which is that of its models' namespace: `FBAInventoryV1`.
/// A word is an acronym before a capital or at the end, so that `Cod` leaves `Code` alone.
fn ruby_class(module: &str) -> String {
    ACRONYMS.iter().fold(pascal(module), |name, (from, to)| {
        let word = regress::Regex::new(&format!("{from}(?=[A-Z]|$)")).expect("valid pattern");
        word.replace_all(&name, to)
    })
}
/// Ruby's keywords. A method named after one can't be called as the others are, and an
/// argument named after one can't be read: the file would not parse.
const RUBY_KEYWORDS: [&str; 35] = [
    "alias", "and", "begin", "break", "case", "class", "def", "do", "else", "elsif", "end",
    "ensure", "false", "for", "if", "in", "module", "next", "nil", "not", "or", "redo", "rescue",
    "retry", "return", "self", "super", "then", "true", "undef", "unless", "until", "when",
    "while", "yield",
];
/// The parts of an operation's Ruby method that its `*_pages` twin shares.
struct RubyMethod {
    /// Its parameter list, in parentheses
    parameters: String,
    /// The statement that builds the arguments for the core
    arguments: String,
    /// Its parameter list in RBS, for the twin's type
    types: String,
}
impl RubyMethod {
    fn of(op: &Operation) -> Result<Self, GenerationError> {
        // v5's signature: required arguments are positional and optional ones keywords,
        // each in the spec's order. A body goes by the name the spec gives it.
        let name = Parameter::ruby_name;
        let mut ordered: Vec<&Parameter> = op.parameters.iter().collect();
        ordered.sort_by_key(|p| (!p.required, p.position));
        // What is refused of an operation names it. The caller names the file.
        let refuse = |what: String| Err(GenerationError(format!("{}: {what}", op.id)));
        if ordered.iter().any(|p| name(p) == "rate_limit") {
            return refuse("a parameter is named rate_limit".into());
        }
        // `initialize` would replace the constructor of the API's class.
        let method = op.ruby_name();
        if RUBY_KEYWORDS.contains(&method) || method == "initialize" {
            return refuse(format!("Ruby can't name its method {method}"));
        }
        let keyword = |p: &&Parameter| RUBY_KEYWORDS.contains(&name(p).as_str());
        if let Some(p) = ordered.iter().copied().find(keyword) {
            return refuse(format!("Ruby can't name an argument {}", name(p)));
        }
        // v5's last keyword: the rate for the wait after a 429, the documented one by
        // default. Every method takes it, so a call keeps working when Amazon adds or
        // removes a usage plan.
        let rate_limit = match op.rate {
            Some(rate) => format!("rate_limit: {rate:?}"),
            None => "rate_limit: nil".into(),
        };
        let parameters = ordered
            .iter()
            .map(|p| match p.schema.get("default") {
                _ if p.required => Ok(name(p)),
                Some(default) => Ok(format!("{}: {}", name(p), ruby_default(default)?)),
                None => Ok(format!("{}: nil", name(p))),
            })
            .chain([Ok(rate_limit)])
            .collect::<Result<Vec<_>, GenerationError>>()?
            .join(", ");
        let types = ordered
            .iter()
            .map(|p| match docs::rbs_type(p) {
                ty if p.required => format!("{ty} {}", name(p)),
                ty => format!("?{}: {ty}", name(p)),
            })
            .chain([format!("?rate_limit: {}", docs::RATE_LIMIT)])
            .collect::<Vec<_>>()
            .join(", ");
        // The core is strict about types. `Arguments` takes the forms v5 took.
        let entries = op
            .parameters
            .iter()
            .map(|p| {
                let options = match p.location.as_str() {
                    // As `path` picks `last_segment` for the Rust.
                    "path" if op.path.ends_with(&format!("{{{}}}", p.wire_name)) => ", last: true",
                    "path" => "",
                    _ if p.required => ", required: true",
                    _ => "",
                };
                format!(
                    "          {}: Arguments.{}({:?}, {}{options}),\n",
                    p.name,
                    ruby_coercion(p),
                    name(p),
                    name(p)
                )
            })
            .collect::<String>();
        Ok(Self {
            parameters: format!("({parameters})"),
            arguments: if entries.is_empty() {
                "        # @type var arguments: Hash[Symbol, untyped]\n        arguments = {}\n"
                    .into()
            } else {
                format!("        arguments = {{\n{entries}        }}\n")
            },
            types,
        })
    }
}
/// The Ruby of every API: its class, its methods and its method on `Client`. Their
/// types are inline RBS, which `rake rbs:export` writes to `sig/inline`.
pub(crate) fn ruby(
    clients: &[(&ModelSpec, Vec<Operation>)],
    resolved: &[Resolved],
    specs: &BTreeMap<&str, Value>,
) -> Result<String, GenerationError> {
    let mut ruby = String::from(
        "# frozen_string_literal: true\n\n# Generated by peddler-codegen. Do not edit.\nmodule Peddler\n  module Native\n",
    );
    ruby.push_str("    PAGINATIONS = {\n");
    for r in resolved {
        writeln!(
            ruby,
            "      {:?} => {},",
            r.key,
            pagination::ruby_expression(r)
        )
        .unwrap();
    }
    // The type of a constant that spans lines is read from its last one.
    ruby.push_str("    }.freeze #: Hash[String, Pagination]\n\n");
    for (api, operations) in clients {
        let class = ruby_class(api.module);
        ruby.push_str(&docs::class(api, &specs[api.module]["info"]));
        // An instance variable's type is read before the first statement of the class
        // only, with a blank line after it. `Client` builds the class and no application
        // does, so RDoc leaves `new` off its page.
        writeln!(
            ruby,
            "    class {class}\n      # @rbs @engine: engine\n\n      #: (engine engine) -> void\n      def initialize(engine) # :nodoc:\n        @engine = engine\n      end\n"
        )
        .unwrap();
        for op in operations {
            let RubyMethod {
                parameters,
                arguments,
                types,
            } = RubyMethod::of(op)
                .map_err(|error| GenerationError(format!("{}: {error}", api.source)))?;
            let key = format!("{}.{}", api.module, op.name);
            // What can't be encoded is in a body, so the error names it.
            let body = op.body().map(Parameter::ruby_name);
            let body = body.map_or(String::new(), |name| format!(", {name:?}"));
            // The response carries its operation key so Ruby can resolve the typed model.
            ruby.push_str(&docs::operation(op));
            writeln!(ruby,"      def {}{parameters}\n{arguments}        Response.from_parts(@engine.operation({key:?}, Arguments.encode(arguments{body}), Arguments.rate_limit(rate_limit)), {key:?})\n      end\n",op.ruby_name()).unwrap();
            if let Some(mapped) = resolved
                .iter()
                .find(|r| r.module == api.module && r.name == op.name)
            {
                ruby.push_str(&docs::pages(op, &types));
                writeln!(ruby,"      def {}_pages{parameters}\n{arguments}        PAGINATIONS.fetch({:?}).pages(@engine, arguments, Arguments.rate_limit(rate_limit))\n      end\n",op.ruby_name(),mapped.key).unwrap();
            }
        }
        ruby.truncate(ruby.trim_end().len());
        ruby.push_str("\n    end\n\n");
    }
    ruby.truncate(ruby.trim_end().len());
    ruby.push_str("\n  end\n\n  class Client\n");
    for (api, _) in clients {
        let class = ruby_class(api.module);
        ruby.push_str(&docs::accessor(&class, &specs[api.module]["info"]));
        writeln!(
            ruby,
            "    def {}\n      Native::{class}.new(@engine)\n    end\n",
            api.module
        )
        .unwrap();
        // Steep reads no alias, so the latest version is a method of its own.
        if api.latest {
            ruby.push_str(&docs::latest(&class, api.module));
            writeln!(ruby, "    def {} = {}\n", api.family, api.module).unwrap();
        }
    }
    ruby.truncate(ruby.trim_end().len());
    ruby.push_str("\n  end\nend\n");
    Ok(ruby)
}
pub(crate) fn inventory(
    clients: &[(&ModelSpec, Vec<Operation>)],
    revision: &str,
    resolved: &[Resolved],
    source: &pagination::Source,
) -> Result<String, GenerationError> {
    let apis: Vec<Value> = clients
        .iter()
        .map(|(api, operations)| {
            let operations: Vec<Value> = operations
                .iter()
                .map(|op| operation_json(api, op, resolved, source))
                .collect();
            json!({
                "source": api.source,
                "module": api.module,
                "family": api.family,
                "version": api.version,
                "latest": api.latest,
                "ruby_class": ruby_class(api.module),
                "operations": operations,
            })
        })
        .collect();
    Ok(serde_json::to_string_pretty(&json!({"revision": revision, "apis": apis}))? + "\n")
}
fn operation_json(
    api: &ModelSpec,
    op: &Operation,
    resolved: &[Resolved],
    source: &pagination::Source,
) -> Value {
    let key = format!("{}.{}", api.module, op.name);
    let parameters: Vec<Value> = op.parameters.iter().map(parameter_json).collect();
    let successes: Vec<Value> = op
        .successes
        .iter()
        .map(|(status, model)| json!({"status": status, "model": model}))
        .collect();
    let pagination = resolved.iter().find(|r| r.key == key).map(|r| {
        let continuation = &r.mapping.continuation;
        json!({
            "input": r.mapping.input,
            "output": r.mapping.output,
            "continuation": {
                "operation": r.continuation_operation,
                "keep": continuation.keep,
                "drop": continuation.drop,
                "set": continuation.set,
                "adapter": continuation.adapter,
            },
        })
    });
    let exclusion = source.exclusions.iter().find(|e| e.operation == key);
    json!({
        "id": op.id,
        "key": key,
        "method": op.method,
        "path": op.path,
        "rate": op.rate,
        "parameters": parameters,
        "successes": successes,
        "pagination": pagination,
        "pagination_exclusion": exclusion.map(|e| &e.reason),
    })
}
fn parameter_json(p: &Parameter) -> Value {
    json!({
        "name": p.name,
        "wire_name": p.wire_name,
        "in": p.location,
        "required": p.required,
        "csv": p.csv,
        "schema": p.schema,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    /// The method that enumerates pages takes its whole type in one line, each kind of
    /// argument in it: positional when required, a keyword that may be nil otherwise,
    /// and `rate_limit:` last.
    #[test]
    fn a_pages_method_carries_its_whole_type() {
        let spec = json!({"swagger":"2.0","produces":["application/json"],"consumes":["application/json"],"info":{"title":"Synthetic","version":"1"},"paths":{
            "/sellers/{sellerId}/items":{"get":{"operationId":"listItems","parameters":[
                {"name":"nextToken","in":"query","type":"string"},
                {"name":"sellerId","in":"path","required":true,"type":"string"},
                {"name":"marketplaceIds","in":"query","required":true,"type":"array","items":{"type":"string"}},
                {"name":"maxResults","in":"query","type":"integer","default":10},
                {"name":"withStock","in":"query","type":"boolean"},
                {"name":"minPrice","in":"query","type":"number"}],
                "responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Page"}}}}}
        },"definitions":{"Page":{"type":"object","properties":{"nextToken":{"type":"string"}}}}});
        let api = &crate::manifest::ALL_APIS[0];
        let clients = vec![(api, crate::clients::render(&spec, api).unwrap())];
        let specs = BTreeMap::from([(api.module, spec)]);
        let key = format!("{}.list_items", api.module);
        let source = json!({"mappings":[{"operation":key,"input":"/next_token","output":"/nextToken"}],"exclusions":[]});
        let source: pagination::Source = serde_json::from_value(source).unwrap();
        let resolved = pagination::resolve(&source, &clients, &specs).unwrap();
        let ruby = ruby(&clients, &resolved, &specs).unwrap();
        assert!(ruby.contains(concat!(
            "      # Each page of #list_items. `rate_limit` applies to every page.\n",
            "      #: (String seller_id, Array[String] marketplace_ids, ?next_token: String?, ?max_results: Integer?, ?with_stock: bool?, ?min_price: (Float | Integer)?, ?rate_limit: (Float | Integer)?) -> Enumerator[Response, void]\n",
            "      def list_items_pages(seller_id, marketplace_ids, next_token: nil, max_results: 10, with_stock: nil, min_price: nil, rate_limit: nil)\n",
        )), "{ruby}");
    }

    /// The Rust of a spec with one operation, which pages if `paged`.
    fn rust_of(operation: Value, paged: bool) -> String {
        let spec = json!({"swagger":"2.0","produces":["application/json"],"info":{"title":"Synthetic","version":"1"},"paths":{
            "/things/{id}":{"post":operation}
        },"definitions":{"Page":{"type":"object","properties":{"nextToken":{"type":"string"}}},"Thing":{"type":"object"}}});
        let api = &crate::manifest::ALL_APIS[0];
        let clients = vec![(api, crate::clients::render(&spec, api).unwrap())];
        let specs = BTreeMap::from([(api.module, spec)]);
        let key = format!("{}.list_things", api.module);
        let source = if paged {
            json!({"mappings":[{"operation":key,"input":"/next_token","output":"/nextToken"}],"exclusions":[]})
        } else {
            json!({"mappings":[],"exclusions":[{"operation":key,"reason":"none"}]})
        };
        let source: pagination::Source = serde_json::from_value(source).unwrap();
        let resolved = pagination::resolve(&source, &clients, &specs).unwrap();
        let mapped: Vec<&Resolved> = resolved.iter().collect();
        rust(&clients[0].1, &mapped).unwrap()
    }

    /// The doc of an item, as rustdoc joins its attributes.
    fn doc_of(attrs: &[syn::Attribute]) -> Option<String> {
        let lines: Vec<String> = attrs
            .iter()
            .filter_map(|attr| match &attr.meta {
                syn::Meta::NameValue(meta) if meta.path.is_ident("doc") => match &meta.value {
                    syn::Expr::Lit(syn::ExprLit {
                        lit: syn::Lit::Str(text),
                        ..
                    }) => Some(text.value()),
                    _ => None,
                },
                _ => None,
            })
            .collect();
        if lines.is_empty() {
            return None;
        }
        // rustdoc takes away the whitespace every line starts with.
        let text = lines.join("\n");
        let indent = |line: &str| line.len() - line.trim_start_matches([' ', '\t']).len();
        let lines_with_text = text.lines().filter(|line| !line.trim().is_empty());
        let common = lines_with_text.map(indent).min().unwrap_or(0);
        let lines = text
            .split('\n')
            .map(|line| line.get(common..).unwrap_or_default());
        Some(lines.collect::<Vec<_>>().join("\n"))
    }

    /// The doc of each item of a source, by its name: `Type.field`, `Type::method`, or
    /// the name of a struct or a function.
    fn docs_of(source: &str) -> BTreeMap<String, String> {
        let mut docs = BTreeMap::new();
        for item in syn::parse_file(source).unwrap().items {
            match item {
                syn::Item::Struct(item) => {
                    let name = item.ident.to_string();
                    for field in &item.fields {
                        let field_name = field.ident.as_ref().unwrap();
                        if let Some(text) = doc_of(&field.attrs) {
                            docs.insert(format!("{name}.{field_name}"), text);
                        }
                    }
                    docs.extend(doc_of(&item.attrs).map(|text| (name, text)));
                }
                syn::Item::Fn(item) => {
                    docs.extend(doc_of(&item.attrs).map(|text| (item.sig.ident.to_string(), text)));
                }
                syn::Item::Impl(item) if item.trait_.is_none() => {
                    let syn::Type::Path(ty) = &*item.self_ty else {
                        continue;
                    };
                    let ty = &ty.path.segments[0].ident;
                    for item in &item.items {
                        if let syn::ImplItem::Fn(method) = item {
                            let name = format!("{ty}::{}", method.sig.ident);
                            docs.extend(doc_of(&method.attrs).map(|text| (name, text)));
                        }
                    }
                }
                _ => {}
            }
        }
        docs
    }

    /// A parameter's doc is its description, then the values it is known to take, in a
    /// paragraph of their own, as a model field's doc lists them.
    #[test]
    fn a_parameter_is_documented_as_a_model_field_is() {
        let operation = json!({"operationId":"listThings","description":"Lists things.","parameters":[
            {"name":"id","in":"path","required":true,"type":"string"},
            {"name":"status","in":"query","type":"string","enum":["Open","Closed"],"description":"The status"},
            {"name":"kinds","in":"query","type":"array","items":{"type":"string","enum":["A","B"]},"description":"Possible values: `A`, `B`."},
            {"name":"sort","in":"query","type":"string","enum":["asc"]},
            {"name":"body","in":"body","schema":{"$ref":"#/definitions/Thing"},"description":"The thing."}],
            "responses":{"200":{"description":"ok"}}});
        let docs = docs_of(&rust_of(operation, false));
        assert_eq!(
            docs["ListThingsParams.status"],
            "The status\n\nKnown values: `Open`, `Closed`."
        );
        assert_eq!(docs["ListThingsParams.kinds"], "Possible values: `A`, `B`.");
        assert_eq!(docs["ListThingsParams.sort"], "Known values: `asc`.");
        assert_eq!(docs["ListThingsParams.body"], "The thing.");
        assert!(!docs.contains_key("ListThingsParams.id"), "{docs:?}");
    }

    /// The struct names the functions that take it. The function takes the text of its
    /// Ruby method, without the usage plan, and names its pages, which name it.
    #[test]
    fn a_function_and_its_parameters_point_to_each_other() {
        let operation = json!({"operationId":"listThings","parameters":[
            {"name":"id","in":"path","required":true,"type":"string"},
            {"name":"nextToken","in":"query","type":"string"}],
            "description":"Lists things.\n\n**Usage Plan:**\n\n| Rate (requests per second) | Burst |\n| ---- | ---- |\n| 2 | 10 |",
            "responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Page"}},"202":{"description":"ok"}}});
        let docs = docs_of(&rust_of(operation.clone(), true));
        for (item, text) in [
            (
                "ListThingsParams",
                "The parameters of [`list_things`] and [`list_things_pages`].",
            ),
            (
                "ListThingsParams::new",
                "Takes the required parameters. Each optional one is `None`, or its default in the spec.",
            ),
            (
                "list_things",
                "Lists things.\n\nIts pages: [`list_things_pages`].",
            ),
            ("list_things_pages", "Each page of [`list_things`]."),
            (
                "ListThingsResponse",
                "The response of [`list_things`]. Nothing is parsed until asked.",
            ),
            (
                "ListThingsResponse.raw",
                "The response as it arrived, whatever its status.",
            ),
            (
                "ListThingsResponse::into_raw",
                "The response as it arrived.",
            ),
            (
                "ListThingsResponse::json_200",
                "Parses the body into the model of a 200 response.",
            ),
        ] {
            assert_eq!(docs.get(item).map(String::as_str), Some(text), "{item}");
        }
        let docs = docs_of(&rust_of(operation, false));
        assert_eq!(
            docs["ListThingsParams"],
            "The parameters of [`list_things`]."
        );
        assert_eq!(docs["list_things"], "Lists things.");
    }

    /// A doc is a line comment for each line. Of a block comment, rustc would read
    /// `*Note**:` for the `**Note**:` that starts its last line.
    #[test]
    fn a_doc_is_written_in_line_comments() {
        let text = "Lists things.\n\n**Note**: slowly.";
        let operation = json!({"operationId":"listThings","description":text,"parameters":[
            {"name":"id","in":"path","required":true,"type":"string","description":text}],
            "responses":{"200":{"description":"ok"}}});
        let source = rust_of(operation, false);
        assert_eq!(
            source.matches("/// **Note**: slowly.\n").count(),
            2,
            "{source}"
        );
        let blocks = source
            .lines()
            .filter(|line| line.trim_start().starts_with("/**"));
        assert_eq!(blocks.count(), 0, "{source}");
        let docs = docs_of(&source);
        assert_eq!(docs["ListThingsParams.id"], text);
    }

    /// A spec is data: whatever its text holds, a doc says it as text, and none of it
    /// ends the comment or adds an item.
    #[test]
    fn a_doc_is_the_text_of_the_spec() {
        let hostile = concat!(
            "a */ pub fn injected() {} /* b\n*/\n/// c\n#[doc = \"d\"] \"e\" \\ \\\" f\n",
            "/* g\r\nh\ri\u{2028}j\u{0}k `l` [m](doc:n)",
        );
        let operation = json!({"operationId":"listThings","description":hostile,"parameters":[
            {"name":"id","in":"path","required":true,"type":"string","description":hostile,"enum":["*/", "\"", "x\ny"]},
            {"name":"other","in":"query","type":"string","description":"*/"},
            {"name":"third","in":"query","type":"string","description":"a\rb"}],
            "responses":{"200":{"description":"ok"}}});
        let source = rust_of(operation, false);
        assert!(!source.contains('\r'), "{source}");
        let docs = docs_of(&source);
        let text = hostile.replace("\r\n", "\n").replace('\r', "\n");
        let text = text.replace("doc:n", "https://developer-docs.amazon.com/sp-api/docs/n");
        assert_eq!(
            docs["ListThingsParams.id"],
            format!("{text}\n\nKnown values: `*/`, `\"`, `x y`.")
        );
        assert_eq!(docs["ListThingsParams.other"], "*/");
        assert_eq!(docs["ListThingsParams.third"], "a\nb");
        assert!(docs["list_things"].starts_with("a */ pub fn injected() {} /* b\n"));
        let items = syn::parse_file(&source).unwrap().items;
        let names: Vec<String> = items
            .iter()
            .filter_map(|item| match item {
                syn::Item::Struct(item) => Some(item.ident.to_string()),
                syn::Item::Fn(item) => Some(item.sig.ident.to_string()),
                _ => None,
            })
            .collect();
        assert_eq!(names, ["ListThingsParams", "list_things"]);
    }

    /// An API's module takes the text of its Ruby class.
    #[test]
    fn a_module_is_documented_as_its_ruby_class_is() {
        let api = &crate::manifest::ALL_APIS[0];
        let info =
            json!({"title":"Things API","description":"For things. See [the guide](doc:guide).\n"});
        let source = format!("{}pub mod things;", module_doc(api, &info));
        let item: syn::ItemMod = syn::parse_str(&source).unwrap();
        assert_eq!(
            doc_of(&item.attrs).unwrap(),
            format!(
                "Things API\n\nFor things. See [the guide](https://developer-docs.amazon.com/sp-api/docs/guide).\n\n<https://github.com/amzn/selling-partner-api-models/blob/main/models/{}>",
                api.source
            )
        );
    }

    /// The Ruby of a spec with one operation, or why it is refused.
    fn ruby_of(id: &str, parameters: Value) -> Result<String, String> {
        let spec = json!({"swagger":"2.0","produces":["application/json"],"info":{"title":"Synthetic","version":"1"},"paths":{
            "/things":{"get":{"operationId":id,"parameters":parameters,"responses":{"200":{"description":"ok"}}}}
        }});
        let api = &crate::manifest::ALL_APIS[0];
        let clients = vec![(api, crate::clients::render(&spec, api).unwrap())];
        let specs = BTreeMap::from([(api.module, spec)]);
        ruby(&clients, &[], &specs).map_err(|error| error.0)
    }

    /// A name from a spec that Ruby can't use is refused, by its file and its operation.
    /// Written out, the file would not parse, or would replace the constructor.
    #[test]
    fn a_name_that_ruby_cant_use_is_refused() {
        let source = crate::manifest::ALL_APIS[0].source;
        let query = |name: &str, required: bool| json!([{"name":name,"in":"query","type":"string","required":required}]);
        for keyword in RUBY_KEYWORDS {
            for required in [false, true] {
                assert_eq!(
                    ruby_of("getThing", query(keyword, required)).unwrap_err(),
                    format!("{source}: getThing: Ruby can't name an argument {keyword}")
                );
            }
            assert_eq!(
                ruby_of(keyword, json!([])).unwrap_err(),
                format!("{source}: {keyword}: Ruby can't name its method {keyword}")
            );
        }
        // A name is a keyword after it is put in snake case, not before.
        assert_eq!(
            ruby_of("getThing", query("End", false)).unwrap_err(),
            format!("{source}: getThing: Ruby can't name an argument end")
        );
        assert_eq!(
            ruby_of("initialize", json!([])).unwrap_err(),
            format!("{source}: initialize: Ruby can't name its method initialize")
        );
        assert_eq!(
            ruby_of("getThing", query("rateLimit", false)).unwrap_err(),
            format!("{source}: getThing: a parameter is named rate_limit")
        );
        assert!(ruby_of("getThing", query("ending", false)).is_ok());
    }

    /// A keyword of Rust takes a `_` in Rust, and in what the core is sent. In Ruby it is
    /// the name v5 gave it.
    #[test]
    fn a_keyword_of_rust_keeps_its_name_in_ruby() {
        let parameters = json!([{"name":"type","in":"query","type":"string"},{"name":"match","in":"query","type":"string","required":true}]);
        let ruby = ruby_of("move", parameters).unwrap();
        let module = crate::manifest::ALL_APIS[0].module;
        for line in [
            "      # @rbs type: String?\n".to_owned(),
            "      # @rbs match: String\n".to_owned(),
            "      def move(match, type: nil, rate_limit: nil)\n".to_owned(),
            "          type_: Arguments.string(\"type\", type),\n".to_owned(),
            "          match_: Arguments.string(\"match\", match, required: true),\n".to_owned(),
            format!("@engine.operation(\"{module}.move_\", "),
        ] {
            assert!(ruby.contains(&line), "{line}{ruby}");
        }
    }

    /// As `Peddler::Acronyms.apply` names them in Ruby.
    #[test]
    fn a_class_is_named_with_peddlers_acronyms() {
        for (module, class) in [
            ("fba_inventory_v1", "FBAInventoryV1"),
            ("orders_v0", "OrdersV0"),
            ("apis_v1", "APIsV1"),
            ("api_urls", "APIURLs"),
            ("b2b_sku_v1", "B2BSKUV1"),
            ("sku_2024_01_01", "Sku20240101"),
            ("code_v1", "CodeV1"),
            ("cod_v1", "CODV1"),
        ] {
            assert_eq!(ruby_class(module), class);
        }
    }

    /// Each literal reads back in Ruby as the spec's text and runs nothing.
    #[test]
    fn a_default_is_written_as_a_literal_that_runs_nothing() {
        for (default, literal) in [
            (json!("#{exit}"), r##""\#{exit}""##),
            (json!("#$0 #@x"), r##""\#$0 \#@x""##),
            (json!("\"; exit; \""), r##""\"; exit; \"""##),
            (json!("\\#{exit}"), r##""\\\#{exit}""##),
            (json!("trailing\\"), r##""trailing\\""##),
            (json!("line\nbreak"), r##""line\nbreak""##),
            (json!(["#{exit}", "plain"]), r##"["\#{exit}", "plain"]"##),
            (json!(10), "10"),
            (json!(1.5), "1.5"),
            (json!(true), "true"),
            (json!(false), "nil"),
            (json!(null), "nil"),
        ] {
            assert_eq!(ruby_default(&default).unwrap(), literal, "{default}");
        }
        for default in [
            json!({"k": "#{exit}"}),
            json!({"#{exit}": 1}),
            json!([{"k": "#{exit}"}]),
            json!([["nested"], {"k": 1}]),
        ] {
            assert!(ruby_default(&default).is_err(), "{default}");
        }
    }
}
