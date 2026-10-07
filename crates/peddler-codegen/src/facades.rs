//! Thin public Rust/Ruby facades derived from operation metadata.
use crate::{
    GenerationError,
    clients::{Operation, Parameter, pascal, rust_type},
    docs, format_source,
    manifest::ModelSpec,
    pagination::{self, Resolved},
};
use serde_json::{Value, json};
use std::fmt::Write;

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
        params_struct(&mut source, op)?;
        call(&mut source, op)?;
        if let Some(mapped) = pagination.iter().find(|r| r.name == op.name) {
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
fn params_struct(source: &mut String, op: &Operation) -> Result<(), GenerationError> {
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
    writeln!(source,"#[derive(Clone, Debug, serde::Deserialize, serde::Serialize)]\n#[serde(deny_unknown_fields)]\npub struct {params}{} {{", body.declared).unwrap();
    for (p, ty, default) in &fields {
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
    writeln!(
        source,
        "impl{} {params}{} {{ pub fn new({required}) -> Self {{ Self {{",
        body.named, body.named
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
/// it has its own.
fn call(source: &mut String, op: &Operation) -> Result<(), GenerationError> {
    let body = BodyType::of(op);
    let (returned, wrapped) = match Returns::of(op) {
        Returns::Raw => ("Response".to_owned(), "raw".to_owned()),
        Returns::Typed(model) => (
            format!("TypedResponse<{model}>"),
            "TypedResponse::new(raw)".to_owned(),
        ),
        Returns::ByStatus(name) => {
            writeln!(source,"#[derive(Debug)] pub struct {name} {{ pub raw: Response }}\nimpl {name} {{ pub fn into_raw(self)->Response {{self.raw}}").unwrap();
            for (status, model) in &op.successes {
                if let Some(model) = model {
                    writeln!(source,"pub fn json_{status}(&self)->Result<{model},DecodeError> {{ crate::operation::decode_status(&self.raw,{status}) }}").unwrap()
                }
            }
            source.push_str("}\n");
            (name.clone(), format!("{name} {{raw}}"))
        }
    };
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
        "let raw = client.execute_json(Request {{ method: {:?}.into(), path: {}, {}, body: {body} }}).await?;",
        op.method,
        path(op)?,
        fields.join(", ")
    )
    .unwrap();
    Ok(())
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
/// client, so the token, retries and timeout are unchanged.
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
        "pub(crate) async fn {}_continue(client:&Client, params:{strukt})->Result<Response,Error> {{\nclient.execute_json(Request {{ method: {:?}.into(), path: {}, query: vec![({wire:?}.into(), params.{token})], headers: Vec::new(), body: None }}).await\n}}",
        op.name,
        op.method,
        path(op)?
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
        "type OperationFuture<'a> = std::pin::Pin<Box<dyn std::future::Future<Output=Result<crate::Response,crate::Error>> + Send + 'a>>;\ntype Handler = for<'a> fn(&'a crate::Client, &'a str)->OperationFuture<'a>;\npub fn execute<'a>(client:&'a crate::Client, operation:&str, arguments:&'a str)->OperationFuture<'a> { let handler: Handler = match operation {\n",
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
fn ruby_type(p: &Parameter) -> String {
    if p.location == "body" {
        "untyped".into()
    } else {
        match p.schema["type"].as_str() {
            Some("array") => "Array[String]",
            Some("boolean") => "bool",
            Some("integer") => "Integer",
            Some("number") => "Float | Integer",
            _ => "String",
        }
        .into()
    }
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
fn ruby_default(value: &Value) -> String {
    match value {
        // v5 left a default of false out, so Amazon's own default applied.
        Value::Null | Value::Bool(false) => "nil".into(),
        Value::Array(values) => format!(
            "[{}]",
            values
                .iter()
                .map(ruby_default)
                .collect::<Vec<_>>()
                .join(", ")
        ),
        _ => value.to_string(),
    }
}
/// The parts of an operation's Ruby method that its `*_pages` twin shares.
struct RubyMethod {
    /// Its parameter list, in parentheses, or nothing
    parameters: String,
    /// The statement that builds the arguments for the core
    arguments: String,
    /// Its parameter list in RBS
    types: String,
}
impl RubyMethod {
    fn of(op: &Operation) -> Self {
        // v5's signature: required arguments are positional and optional ones keywords,
        // each in the spec's order. A body goes by the name the spec gives it.
        let name = |p: &Parameter| crate::clients::snake(&p.wire_name);
        let mut ordered: Vec<&Parameter> = op.parameters.iter().collect();
        ordered.sort_by_key(|p| (!p.required, p.position));
        let parameters = ordered
            .iter()
            .map(|p| match p.schema.get("default") {
                _ if p.required => name(p),
                Some(default) => format!("{}: {}", name(p), ruby_default(default)),
                None => format!("{}: nil", name(p)),
            })
            .collect::<Vec<_>>()
            .join(", ");
        let types = ordered
            .iter()
            .map(|p| match ruby_type(p) {
                ty if p.required => format!("{ty} {}", name(p)),
                ty if ty.contains('|') => format!("?{}: ({ty})?", name(p)),
                ty => format!("?{}: {ty}?", name(p)),
            })
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
        Self {
            parameters: if parameters.is_empty() {
                String::new()
            } else {
                format!("({parameters})")
            },
            arguments: if entries.is_empty() {
                "        # @type var arguments: Hash[Symbol, untyped]\n        arguments = {}\n"
                    .into()
            } else {
                format!("        arguments = {{\n{entries}        }}\n")
            },
            types,
        }
    }
}
pub(crate) fn ruby(
    clients: &[(&ModelSpec, Vec<Operation>)],
    resolved: &[Resolved],
) -> (String, String) {
    let mut ruby = String::from(
        "# frozen_string_literal: true\n\n# Generated by peddler-codegen. Do not edit.\nmodule Peddler\n  module Native\n",
    );
    let mut rbs = String::from(
        "# Generated by peddler-codegen. Do not edit.\nmodule Peddler\n  module Native\n",
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
    ruby.push_str("    }.freeze\n\n");
    rbs.push_str("    PAGINATIONS: Hash[String, Pagination]\n\n");
    for (api, operations) in clients {
        let class = pascal(api.module);
        writeln!(
            ruby,
            "    class {class}\n      def initialize(engine)\n        @engine = engine\n      end\n"
        )
        .unwrap();
        writeln!(rbs,"    class {class}\n      @engine: engine\n      def initialize: (engine engine) -> void").unwrap();
        for op in operations {
            let RubyMethod {
                parameters,
                arguments,
                types,
            } = RubyMethod::of(op);
            let key = format!("{}.{}", api.module, op.name);
            // The response carries its operation key so Ruby can resolve the typed model.
            ruby.push_str(&docs::operation(op));
            writeln!(ruby,"      def {}{parameters}\n{arguments}        Response.from_parts(@engine.operation({key:?}, JSON.generate(arguments)), {key:?})\n      end\n",op.name).unwrap();
            writeln!(rbs, "      def {}: ({types}) -> Response", op.name).unwrap();
            if let Some(mapped) = resolved
                .iter()
                .find(|r| r.module == api.module && r.name == op.name)
            {
                ruby.push_str(&docs::pages(op));
                writeln!(ruby,"      def {}_pages{parameters}\n{arguments}        PAGINATIONS.fetch({:?}).pages(@engine, arguments)\n      end\n",op.name,mapped.key).unwrap();
                writeln!(
                    rbs,
                    "      def {}_pages: ({types}) -> Enumerator[Response, void]",
                    op.name
                )
                .unwrap();
            }
        }
        ruby.truncate(ruby.trim_end().len());
        ruby.push_str("\n    end\n\n");
        rbs.push_str("    end\n\n");
    }
    ruby.truncate(ruby.trim_end().len());
    rbs.truncate(rbs.trim_end().len());
    ruby.push_str("\n  end\n\n  class Client\n");
    rbs.push_str("\n  end\n\n  class Client\n");
    for (api, _) in clients {
        let class = pascal(api.module);
        writeln!(
            ruby,
            "    def {}\n      Native::{class}.new(@engine)\n    end\n",
            api.module
        )
        .unwrap();
        writeln!(rbs, "    def {}: () -> Native::{class}", api.module).unwrap();
        if api.latest {
            writeln!(ruby, "    alias_method :{}, :{}\n", api.family, api.module).unwrap();
            writeln!(rbs, "    alias {} {}", api.family, api.module).unwrap();
        }
    }
    ruby.truncate(ruby.trim_end().len());
    ruby.push_str("\n  end\nend\n");
    rbs.push_str("  end\nend\n");
    (ruby, rbs)
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
                "ruby_class": pascal(api.module),
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
