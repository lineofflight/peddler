//! Thin public Rust/Ruby facades derived from operation metadata.
use crate::{
    GenerationError,
    clients::{Operation, Parameter, RenderedClient, pascal, rust_type},
    manifest::ModelSpec,
    pagination::{self, Resolved},
};
use serde_json::{Value, json};
use std::fmt::Write;

fn format(source: String) -> Result<String, GenerationError> {
    let file =
        syn::parse_file(&source).map_err(|e| GenerationError(format!("facade syntax: {e}")))?;
    Ok(prettyplease::unparse(&file))
}
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
fn default_name(op: &Operation, p: &Parameter) -> String {
    format!("{}_{}_default", op.name, p.name)
}
fn response_type(op: &Operation) -> String {
    let models: std::collections::BTreeSet<_> = op.successes.iter().map(|(_, m)| m).collect();
    if models.len() == 1
        && let Some(Some(model)) = models.first()
    {
        format!("TypedResponse<{model}>")
    } else if models.iter().any(|m| m.is_some()) {
        format!("{}Response", pascal(&op.name))
    } else {
        "Response".into()
    }
}
pub(crate) fn rust(
    client: &RenderedClient,
    pagination: &[&Resolved],
) -> Result<String, GenerationError> {
    let mut source = String::from(
        "use crate::{Client, Error, Request, Response};\nuse crate::operation::{self, DecodeError, TypedResponse};\n",
    );
    for op in &client.operations {
        let params = format!("{}Params", pascal(&op.name));
        let body = op.body();
        let generic = if body.is_some() {
            "<B = serde_json::Value>"
        } else {
            ""
        };
        for p in &op.parameters {
            if !p.required
                && let Some(default) = p.schema.get("default")
            {
                let name = default_name(op, p);
                let ty = field_type(p)?;
                let serialized = serde_json::to_string(default)?;
                writeln!(source,"fn {name}() -> {ty} {{ Some(serde_json::from_str({serialized:?}).expect(\"validated schema default\")) }}").unwrap();
            }
        }
        writeln!(source,"#[derive(Clone, Debug, serde::Deserialize, serde::Serialize)]\n#[serde(deny_unknown_fields)]\npub struct {params}{generic} {{").unwrap();
        for p in &op.parameters {
            if !p.required && p.schema.get("default").is_some() {
                writeln!(source, "#[serde(default = {:?})]", default_name(op, p)).unwrap()
            }
            let ty = field_type(p)?;
            writeln!(source, "pub {}: {ty},", p.name).unwrap();
        }
        source.push_str("}\n");
        let implementation = if body.is_some() {
            format!("impl<B> {params}<B>")
        } else {
            format!("impl {params}")
        };
        writeln!(
            source,
            "{implementation} {{ pub fn new({}) -> Self {{ Self {{",
            op.parameters
                .iter()
                .filter(|p| p.required)
                .map(|p| Ok(format!("{}: {}", p.name, field_type(p)?)))
                .collect::<Result<Vec<_>, GenerationError>>()?
                .join(", ")
        )
        .unwrap();
        for p in &op.parameters {
            let initial = if p.required {
                p.name.clone()
            } else if p.schema.get("default").is_some() {
                format!("{}()", default_name(op, p))
            } else {
                "None".into()
            };
            if p.required {
                writeln!(source, "{},", p.name).unwrap();
            } else {
                writeln!(source, "{}: {initial},", p.name).unwrap();
            }
        }
        source.push_str("} } }\n");
        if op.parameters.iter().all(|p| !p.required) {
            let default_impl = if body.is_some() {
                format!("impl<B> Default for {params}<B>")
            } else {
                format!("impl Default for {params}")
            };
            writeln!(
                source,
                "{default_impl} {{ fn default() -> Self {{ Self::new() }} }}"
            )
            .unwrap();
        }
        let response = response_type(op);
        if response.ends_with("Response") && response != "Response" {
            writeln!(source,"#[derive(Debug)] pub struct {response} {{ pub raw: Response }}\nimpl {response} {{ pub fn into_raw(self)->Response {{self.raw}}").unwrap();
            for (status, model) in &op.successes {
                if let Some(model) = model {
                    writeln!(source,"pub fn json_{status}(&self)->Result<{model},DecodeError> {{ crate::operation::decode_status(&self.raw,{status}) }}").unwrap()
                }
            }
            source.push_str("}\n");
        }
        let generic_fn = if body.is_some() {
            "<B: serde::Serialize>"
        } else {
            ""
        };
        let params_ty = if body.is_some() {
            format!("{params}<B>")
        } else {
            params
        };
        writeln!(source,"pub async fn {}{generic_fn}(client:&Client, params:{params_ty})->Result<{response},Error> {{",op.name).unwrap();
        request(&mut source, op)?;
        if response == "Response" {
            source.push_str("Ok(raw)\n")
        } else if response.starts_with("TypedResponse<") {
            source.push_str("Ok(TypedResponse::new(raw))\n")
        } else {
            writeln!(source, "Ok({response} {{raw}})").unwrap()
        }
        source.push_str("}\n");
        if let Some(mapped) = pagination.iter().find(|r| r.name == op.name) {
            let params_ty = if body.is_some() {
                format!("{}Params<B>", pascal(&op.name))
            } else {
                format!("{}Params", pascal(&op.name))
            };
            let generics = if body.is_some() {
                "<'a, B: serde::Serialize>"
            } else {
                "<'a>"
            };
            writeln!(source,"pub fn {}_pages{generics}(client:&'a Client, params:{params_ty}, max_pages: Option<usize>)->crate::pagination::PageStream<'a> {{ crate::pagination::pages(client, {}, &params, max_pages) }}",op.name,pagination::rust_expression(mapped)).unwrap();
            if mapped.mapping.continuation.adapter {
                adapter(&mut source, op, mapped)?;
            }
        }
    }
    // Some operations have no typed decoder or no parameter at all.
    Ok(format!(
        "#![allow(unused_imports, unused_variables, clippy::too_many_arguments)]\n{}",
        format(source)?
    ))
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
    let entries = resolved
        .iter()
        .map(|r| format!("{},", pagination::rust_expression(r)))
        .collect::<String>();
    format(format!(
        "/// Every explicit pagination mapping, from `pagination.json`.\npub fn mappings() -> Vec<crate::pagination::Pagination> {{ vec![{entries}] }}\npub fn mapping(operation: &str) -> Option<crate::pagination::Pagination> {{ mappings().into_iter().find(|p| p.operation == operation) }}\n"
    ))
}
pub(crate) fn dispatch(
    clients: &[(&ModelSpec, RenderedClient)],
    resolved: &[Resolved],
) -> Result<String, GenerationError> {
    let mut source = String::from(
        "type OperationFuture<'a> = std::pin::Pin<Box<dyn std::future::Future<Output=Result<crate::Response,crate::Error>> + Send + 'a>>;\ntype Handler = for<'a> fn(&'a crate::Client, &'a str)->OperationFuture<'a>;\npub fn execute<'a>(client:&'a crate::Client, operation:&str, arguments:&'a str)->OperationFuture<'a> { let handler: Handler = match operation {\n",
    );
    for (api, client) in clients {
        for op in &client.operations {
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
    for (api, client) in clients {
        for op in &client.operations {
            let params = pascal(&op.name) + "Params";
            let annotation = if op.body().is_some() {
                format!("crate::apis::{}::{params}<serde_json::Value>", api.module)
            } else {
                format!("crate::apis::{}::{params}", api.module)
            };
            let expression = if response_type(op) == "Response" {
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
    format(source)
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
fn ruby_default(value: &Value) -> String {
    match value {
        Value::Null => "nil".into(),
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
pub(crate) fn ruby(
    clients: &[(&ModelSpec, RenderedClient)],
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
    for (api, client) in clients {
        let class = pascal(api.module);
        writeln!(
            ruby,
            "    class {class}\n      def initialize(engine)\n        @engine = engine\n      end\n"
        )
        .unwrap();
        writeln!(rbs,"    class {class}\n      @engine: engine\n      def initialize: (engine engine) -> void").unwrap();
        for op in &client.operations {
            let keywords = op
                .parameters
                .iter()
                .map(|p| {
                    if p.required {
                        format!("{}:", p.name)
                    } else {
                        format!(
                            "{}: {}",
                            p.name,
                            p.schema
                                .get("default")
                                .map(ruby_default)
                                .unwrap_or("nil".into())
                        )
                    }
                })
                .collect::<Vec<_>>()
                .join(", ");
            let args = op
                .parameters
                .iter()
                .map(|p| format!("{}: {}", p.name, p.name))
                .collect::<Vec<_>>()
                .join(", ");
            let arguments = if args.is_empty() {
                "{}".into()
            } else {
                format!("{{ {args} }}")
            };
            let annotation = if args.is_empty() {
                "        # @type var arguments: Hash[Symbol, untyped]\n"
            } else {
                ""
            };
            let key = format!("{}.{}", api.module, op.name);
            // The response carries its operation key so Ruby can resolve the typed model.
            writeln!(ruby,"      def {}{}\n{annotation}        arguments = {arguments}\n        Response.from_parts(@engine.operation({key:?}, JSON.generate(arguments)), {key:?})\n      end\n",op.name,if keywords.is_empty(){String::new()}else{format!("({keywords})")}).unwrap();
            let sig = op
                .parameters
                .iter()
                .map(|p| {
                    let ty = ruby_type(p);
                    if p.required {
                        format!("{}: {ty}", p.name)
                    } else {
                        format!(
                            "?{}: {}?",
                            p.name,
                            if ty.contains('|') {
                                format!("({ty})")
                            } else {
                                ty
                            }
                        )
                    }
                })
                .collect::<Vec<_>>()
                .join(", ");
            writeln!(rbs, "      def {}: ({sig}) -> Response", op.name).unwrap();
            if let Some(mapped) = resolved
                .iter()
                .find(|r| r.module == api.module && r.name == op.name)
            {
                let signature = if keywords.is_empty() {
                    "max_pages: nil".to_owned()
                } else {
                    format!("{keywords}, max_pages: nil")
                };
                writeln!(ruby,"      def {}_pages({signature})\n{annotation}        arguments = {arguments}\n        PAGINATIONS.fetch({:?}).pages(@engine, arguments, max_pages: max_pages)\n      end\n",op.name,mapped.key).unwrap();
                let sig = if sig.is_empty() {
                    "?max_pages: Integer?".to_owned()
                } else {
                    format!("{sig}, ?max_pages: Integer?")
                };
                writeln!(
                    rbs,
                    "      def {}_pages: ({sig}) -> Enumerator[Response, void]",
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
    clients: &[(&ModelSpec, RenderedClient)],
    revision: &str,
    resolved: &[Resolved],
    source: &pagination::Source,
) -> Result<String, GenerationError> {
    let apis=clients.iter().map(|(api,client)|json!({"source":api.source,"module":api.module,"family":api.family,"version":api.version,"latest":api.latest,"ruby_class":pascal(api.module),"operations":client.operations.iter().map(|op|json!({"id":op.id,"key":format!("{}.{}",api.module,op.name),"method":op.method,"path":op.path,"parameters":op.parameters.iter().map(|p|json!({"name":p.name,"wire_name":p.wire_name,"in":p.location,"required":p.required,"csv":p.csv,"schema":p.schema,"body_type":p.body_type})).collect::<Vec<_>>(),"successes":op.successes.iter().map(|(status,model)|json!({"status":status,"model":model})).collect::<Vec<_>>(),"pagination":resolved.iter().find(|r|r.module==api.module&&r.name==op.name).map(|r|json!({"input":r.mapping.input,"output":r.mapping.output,"continuation":{"operation":r.continuation_operation,"keep":r.mapping.continuation.keep,"drop":r.mapping.continuation.drop,"set":r.mapping.continuation.set,"adapter":r.mapping.continuation.adapter}})),"pagination_exclusion":source.exclusions.iter().find(|e|e.operation==format!("{}.{}",api.module,op.name)).map(|e|e.reason.clone())})).collect::<Vec<_>>()})).collect::<Vec<_>>();
    Ok(serde_json::to_string_pretty(&json!({"revision":revision,"apis":apis}))? + "\n")
}
