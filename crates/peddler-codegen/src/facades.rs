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
    api: &ModelSpec,
    pagination: &[&Resolved],
) -> Result<String, GenerationError> {
    let mut source = String::from(
        "use crate::{Client, Error, Response};\nuse crate::operation::{collect, TypedResponse, DecodeError, WireContext, validate_parameter};\nuse super::wire;\n",
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
        source.push_str("let mut empty_queries = Vec::new();\n");
        for p in &op.parameters {
            if p.location == "body" {
                continue;
            }
            let schema = serde_json::to_string(&p.schema)?;
            let call = format!(
                "validate_parameter(value, {:?}, {schema:?}, {}, {})?;",
                p.location, p.required, p.csv
            );
            // Validate serialized primitive values to keep one shared validator
            // for scalar formats, bounds, patterns, headers and array rules.
            if p.required {
                let borrow = if matches!(p.schema["type"].as_str(), Some("boolean" | "integer")) {
                    ""
                } else {
                    "&"
                };
                writeln!(source,"{{ let value = serde_json::to_value({borrow}params.{}).map_err(|_|Error::InvalidRequest)?; {call} }}",p.name).unwrap();
                if p.schema["type"] == "array" {
                    writeln!(
                        source,
                        "if params.{}.is_empty() {{ empty_queries.push({:?}); }}",
                        p.name, p.wire_name
                    )
                    .unwrap()
                }
            } else {
                writeln!(source,"if let Some(parameter) = &params.{} {{ let value=serde_json::to_value(parameter).map_err(|_|Error::InvalidRequest)?; {call}",p.name).unwrap();
                if p.schema["type"] == "array" {
                    writeln!(
                        source,
                        "if parameter.is_empty() {{empty_queries.push({:?});}}",
                        p.wire_name
                    )
                    .unwrap()
                }
                source.push_str("}\n");
            }
        }
        if let Some(body) = body {
            let optional = if body.required {
                "false"
            } else {
                "params.body.is_none()"
            };
            writeln!(source, "let omit_body = {optional};").unwrap();
            if body.required {
                source.push_str("let body = serde_json::to_value(&params.body).map_err(|_|Error::InvalidRequest)?;\n")
            } else {
                source.push_str("let body = params.body.as_ref().map(serde_json::to_value).transpose().map_err(|_|Error::InvalidRequest)?.unwrap_or(serde_json::Value::Null);\n")
            }
            // Keep bodies flexible; reject wrong top-level shape when the API
            // schema is object/array, without rebuilding nested typed models.
            let schema_kind = body.body_type.clone().unwrap_or_else(|| "object".into());
            if ["object", "array"].contains(&schema_kind.as_str()) {
                writeln!(
                    source,
                    "if !omit_body && !body.is_{}() {{ return Err(Error::InvalidRequest); }}",
                    schema_kind
                )
                .unwrap();
            }
        } else {
            source.push_str("let omit_body = false;\n")
        }
        let key = format!("{}.{}", api.module, op.name);
        writeln!(source,"let raw = client.run({key:?}, {:?}, |snapshot| {{ let params=&params; let empty_queries=empty_queries.clone();",op.method).unwrap();
        if body.is_some() {
            source.push_str("let body=body.clone();\n")
        }
        source.push_str("async move { let wire=wire::Client::new_with_client(snapshot.origin.as_str().trim_end_matches('/'), snapshot.http.clone(), WireContext {client:snapshot.clone(),empty_queries,omit_body});\n");
        writeln!(source, "let mut request=wire.{}();", op.name).unwrap();
        for p in &op.parameters {
            let method = if p.location == "header" {
                crate::clients::snake(&p.wire_name.to_ascii_lowercase())
            } else {
                p.name.clone()
            };
            if p.location == "body" {
                source.push_str("request=request.body(body);\n")
            } else if p.schema["type"] == "number" {
                if p.required {
                    writeln!(
                        source,
                        "request=request.{method}(params.{}.to_string());",
                        p.name
                    )
                    .unwrap()
                } else {
                    writeln!(
                        source,
                        "if let Some(value)=&params.{} {{ request=request.{method}(value.to_string()); }}",
                        p.name
                    )
                    .unwrap()
                }
            } else if p.required {
                writeln!(
                    source,
                    "request=request.{method}(params.{}.clone());",
                    p.name
                )
                .unwrap()
            } else {
                writeln!(
                    source,
                    "if let Some(value)=params.{}.clone() {{ request=request.{method}(value); }}",
                    p.name
                )
                .unwrap()
            }
        }
        source.push_str("collect(request.send().await).await } }).await?;\n");
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
    // Progenitor consumes snake_case OperationInfo, so CSV metadata is looked up
    // per operation. exec is only entered from the shared policy runner.
    source.push_str("impl progenitor_client::ClientHooks<WireContext> for wire::Client {\nasync fn pre<E>(&self, request:&mut reqwest::Request, info:&progenitor_client::OperationInfo)->Result<(),progenitor_client::Error<E>> { self.inner.prepare(request,super::metadata::csv_query_names(info.operation_id)).map_err(|_|progenitor_client::Error::InvalidRequest(\"invalid request\".into())) }\nasync fn exec(&self, request:reqwest::Request, _info:&progenitor_client::OperationInfo)->reqwest::Result<reqwest::Response> {self.inner.client.http.execute(request).await}\n}\n");
    // Generated forwarding uses clones uniformly and some operations have no
    // optional fields, typed decoders or parameters at all.
    Ok(format!(
        "#![allow(unused_imports, unused_variables, unused_mut, clippy::clone_on_copy, clippy::too_many_arguments)]\n{}",
        format(source)?
    ))
}
/// A private continuation operation for APIs whose token replaces every other
/// parameter: it sends the token and path parameters only, so the initial
/// request's required filters are not demanded again. It is still run under
/// the original operation key, so policy, auth and timeouts are unchanged.
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
    writeln!(
        source,
        "pub(crate) async fn {}_continue(client:&Client, params:{strukt})->Result<Response,Error> {{",
        op.name
    )
    .unwrap();
    for p in &kept {
        let schema = serde_json::to_string(&p.schema)?;
        writeln!(source,"validate_parameter(serde_json::Value::String(params.{}.clone()), {:?}, {schema:?}, true, false)?;",p.name,p.location).unwrap();
    }
    let mut template = String::new();
    let mut arguments = Vec::new();
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
        template.push_str(before);
        template.push_str("{}");
        arguments.push(format!(
            "crate::operation::encode_segment(&params.{})",
            p.name
        ));
        rest = tail;
    }
    template.push_str(rest);
    let wire = op
        .parameters
        .iter()
        .find(|p| p.name == token)
        .expect("resolved token")
        .wire_name
        .clone();
    let call = if arguments.is_empty() {
        format!("{template:?}.to_owned()")
    } else {
        format!("format!({template:?}, {})", arguments.join(", "))
    };
    writeln!(
        source,
        "let path = {call};\nclient.execute_json_operation({:?}, crate::Request {{ method: {:?}.into(), path, query: vec![({wire:?}.into(), params.{token})], body: None }}).await\n}}",
        mapped.key, op.method
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
        writeln!(rbs,"    class {class}\n      @engine: Engine\n      def initialize: (Engine engine) -> void").unwrap();
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
