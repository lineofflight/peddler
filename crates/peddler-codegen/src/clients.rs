//! All pinned Progenitor wire clients and operation metadata.
use crate::{GenerationError, manifest::ModelSpec};
use heck::{ToPascalCase, ToSnakeCase};
use serde_json::{Value, json};
use std::{
    io::Write,
    process::{Command, Stdio},
};

pub struct RenderedClient {
    pub wire: String,
    pub operations: Vec<Operation>,
}
#[derive(Debug)]
pub struct Operation {
    pub id: String,
    pub name: String,
    pub method: String,
    pub path: String,
    pub parameters: Vec<Parameter>,
    pub successes: Vec<(u16, Option<String>)>,
}
#[derive(Debug)]
pub struct Parameter {
    pub name: String,
    pub wire_name: String,
    pub location: String,
    pub required: bool,
    pub schema: Value,
    pub csv: bool,
    pub body_type: Option<String>,
}
impl Operation {
    pub fn csv_query_names(&self) -> Vec<&str> {
        self.parameters
            .iter()
            .filter(|p| p.csv)
            .map(|p| p.wire_name.as_str())
            .collect()
    }
    pub fn body(&self) -> Option<&Parameter> {
        self.parameters.iter().find(|p| p.location == "body")
    }
}
pub(crate) fn snake(name: &str) -> String {
    let result = name.to_snake_case();
    if typify::accept_as_ident(&result) {
        result
    } else {
        format!("{result}_")
    }
}
pub(crate) fn pascal(name: &str) -> String {
    name.to_pascal_case()
}

pub fn render(spec: &Value, api: &ModelSpec) -> Result<RenderedClient, GenerationError> {
    let mut converted = convert(spec)?;
    let components = converted["components"].clone();
    let paths = converted["paths"]
        .as_object_mut()
        .ok_or_else(|| GenerationError("missing paths".into()))?;
    let mut counts = std::collections::BTreeMap::new();
    for methods in paths.values() {
        for (method, operation) in methods.as_object().into_iter().flatten() {
            if ["get", "post", "put", "patch", "delete", "head", "options"]
                .contains(&method.as_str())
                && let Some(id) = operation["operationId"].as_str()
            {
                *counts.entry(id.to_owned()).or_insert(0usize) += 1;
            }
        }
    }
    let mut operations = Vec::new();
    let mut seen_wire_ids = std::collections::BTreeSet::new();
    for (path, methods) in paths {
        let path_parameters = methods
            .get("parameters")
            .and_then(Value::as_array)
            .cloned()
            .unwrap_or_default();
        for (method, value) in methods.as_object_mut().into_iter().flatten() {
            if !["get", "post", "put", "patch", "delete", "head", "options"]
                .contains(&method.as_str())
            {
                continue;
            }
            let Some(id) = value["operationId"].as_str().map(str::to_owned) else {
                continue;
            };
            let wire_id = if counts.get(&id).copied().unwrap_or(0) > 1 {
                if api.module == "shipping_v2" && id == "linkCarrierAccount" && method == "put" {
                    format!("{id}_{method}")
                } else if api.module == "shipping_v2"
                    && id == "linkCarrierAccount"
                    && method == "post"
                {
                    id.clone()
                } else {
                    return Err(GenerationError(format!(
                        "{}: duplicate operationId {id}",
                        api.module
                    )));
                }
            } else {
                id.clone()
            };
            if !seen_wire_ids.insert(wire_id.clone()) {
                return Err(GenerationError(format!(
                    "{}: duplicate operationId {id}",
                    api.module
                )));
            }
            value["operationId"] = json!(wire_id);
            let mut parameters = path_parameters.clone();
            for parameter in value["parameters"].as_array().into_iter().flatten() {
                let resolved = resolve(parameter, &components)?;
                parameters
                    .retain(|p| !(p["name"] == resolved["name"] && p["in"] == resolved["in"]));
                parameters.push(resolved.clone());
            }
            let mut params = Vec::new();
            let mut wire_params = Vec::new();
            for value in parameters {
                let mut value = resolve(&value, &components)?.clone();
                let wire_name = value["name"]
                    .as_str()
                    .ok_or_else(|| GenerationError("missing parameter name".into()))?
                    .to_owned();
                let location = value["in"].as_str().unwrap_or("").to_owned();
                let required = value["required"] == true;
                let mut schema = value["schema"].clone();
                if schema["type"] == "string" && schema["format"] == "boolean" {
                    schema["type"] = json!("boolean");
                    if let Some(default) = schema["default"].as_str() {
                        schema["default"] = json!(
                            default
                                .parse::<bool>()
                                .map_err(|_| GenerationError("invalid boolean default".into()))?
                        )
                    }
                }
                let csv = schema["type"] == "array" && value["explode"] != true;
                if csv && schema["default"].is_string() {
                    if api.module == "catalog_items_2020_12_01"
                        && wire_name == "includedData"
                        && schema["default"] == "summaries"
                    {
                        schema["default"] = json!(["summaries"]);
                    } else {
                        return Err(GenerationError(format!(
                            "unexplained scalar array default for {wire_name}"
                        )));
                    }
                }
                if !["path", "query", "header"].contains(&location.as_str())
                    || (location == "path" && !required)
                {
                    return Err(GenerationError(format!(
                        "unsupported {location} parameter {wire_name}"
                    )));
                }
                if schema["type"] == "array"
                    && (location != "query"
                        || (value.get("style").is_some() && value["style"] != "form")
                        || schema["items"]["type"] != "string")
                {
                    return Err(GenerationError(format!(
                        "unsupported array parameter {wire_name}"
                    )));
                }
                let param = Parameter {
                    name: snake(&wire_name),
                    wire_name,
                    location,
                    required,
                    schema: schema.clone(),
                    csv,
                    body_type: None,
                };
                rust_type(&param)?;
                validate_default(&param)?;
                // Facade validates constraints before authorization. Keep the wire
                // builder primitive so Progenitor's parameter wrappers can't defer
                // validation into the authenticated execution closure.
                let mut wire_schema = match schema["type"].as_str() {
                    Some("array") => json!({"type":"array","items":{"type":"string"}}),
                    Some("integer") => {
                        json!({"type":"integer","format":if schema["format"] == "int32" {"int32"} else {"int64"}})
                    }
                    Some("number") => json!({"type":"string"}),
                    Some(kind @ ("string" | "boolean")) => json!({"type":kind}),
                    _ => return Err(GenerationError("unsupported parameter schema".into())),
                };
                // Header names are case-insensitive; reqwest requires lowercase
                // static names. Preserve original spelling in the inventory.
                if param.location == "header" {
                    value["name"] = json!(param.wire_name.to_ascii_lowercase());
                }
                std::mem::swap(&mut value["schema"], &mut wire_schema);
                params.push(param);
                wire_params.push(value);
            }
            value["parameters"] = json!(wire_params);
            if !value["requestBody"].is_null() {
                let mut body = resolve(&value["requestBody"], &components)?.clone();
                let media = body["content"]["application/json"]
                    .as_object_mut()
                    .ok_or_else(|| GenerationError(format!("{id}: unsupported request media")))?;
                let schema = media.get("schema").cloned().unwrap_or(Value::Null);
                let required = body["required"] == true;
                params.push(Parameter {
                    name: "body".into(),
                    wire_name: "body".into(),
                    location: "body".into(),
                    required,
                    body_type: resolve(&schema, &components)?["type"]
                        .as_str()
                        .map(str::to_owned),
                    schema,
                    csv: false,
                });
                body["content"]["application/json"]["schema"] = json!({});
                value["requestBody"] = body;
            }
            let mut successes = Vec::new();
            for (status, response) in value["responses"].as_object().into_iter().flatten() {
                if !status.starts_with('2') {
                    continue;
                }
                let status = status
                    .parse::<u16>()
                    .map_err(|_| GenerationError("success range unsupported".into()))?;
                let response = resolve(response, &components)?;
                let schema = &response["content"]["application/json"]["schema"];
                let model = if matches!(status, 204 | 205) {
                    None
                } else if let Some(reference) = schema["$ref"].as_str() {
                    let name = reference
                        .strip_prefix("#/components/schemas/")
                        .ok_or_else(|| GenerationError("external success schema".into()))?;
                    if components["schemas"].get(name).is_none() {
                        return Err(GenerationError(format!("missing success schema {name}")));
                    }
                    Some(format!("super::models::{}", pascal(name)))
                } else if schema["type"] == "string" {
                    Some("String".into())
                } else if schema.is_null() {
                    None
                } else {
                    return Err(GenerationError(format!(
                        "{id}: unsupported inline success schema"
                    )));
                };
                successes.push((status, model));
            }
            value["x-peddler-raw-response"] = json!(true);
            operations.push(Operation {
                name: snake(&wire_id),
                id,
                method: method.to_ascii_uppercase(),
                path: path.clone(),
                parameters: params,
                successes,
            });
        }
        // Already merged into each operation, including overrides.
        methods.as_object_mut().unwrap().remove("parameters");
    }
    operations.sort_by(|a, b| a.name.cmp(&b.name));
    let mut settings = progenitor::GenerationSettings::default();
    settings
        .with_interface(progenitor::InterfaceStyle::Builder)
        .with_inner_type(quote::quote!(crate::operation::WireContext));
    for (name, schema) in converted["components"]["schemas"]
        .as_object_mut()
        .into_iter()
        .flatten()
    {
        normalize_schema(schema);
        settings.with_replacement(
            name,
            format!("crate::apis::{}::models::{}", api.module, pascal(name)),
            std::iter::empty(),
        );
    }
    let parsed = serde_json::from_value(converted)?;
    let tokens = progenitor::Generator::new(&settings)
        .generate_tokens(&parsed)
        .map_err(|e| GenerationError(format!("{}: {e}", api.source)))?;
    Ok(RenderedClient {
        wire: crate::format_tokens(tokens)?,
        operations,
    })
}
fn resolve<'a>(value: &'a Value, components: &'a Value) -> Result<&'a Value, GenerationError> {
    if let Some(reference) = value["$ref"].as_str() {
        let pointer = reference
            .strip_prefix("#/components/")
            .ok_or_else(|| GenerationError("external reference".into()))?;
        components
            .pointer(&format!("/{pointer}"))
            .ok_or_else(|| GenerationError(format!("missing {reference}")))
    } else {
        Ok(value)
    }
}
fn validate_default(p: &Parameter) -> Result<(), GenerationError> {
    let Some(default) = p.schema.get("default") else {
        return Ok(());
    };
    let valid = match p.schema["type"].as_str() {
        Some("string") => default.is_string(),
        Some("boolean") => default.is_boolean(),
        Some("integer") if p.schema["format"] == "int32" => default
            .as_i64()
            .is_some_and(|value| i32::try_from(value).is_ok()),
        Some("integer") => default.as_i64().is_some(),
        Some("number") => default.as_f64().is_some_and(f64::is_finite),
        Some("array") => default.as_array().is_some_and(|values| {
            values.iter().all(|value| {
                value
                    .as_str()
                    .is_some_and(|text| !text.is_empty() && (!p.csv || !text.contains(',')))
            })
        }),
        _ => false,
    };
    if !valid {
        return Err(GenerationError(format!(
            "invalid default for {}",
            p.wire_name
        )));
    }
    Ok(())
}
pub(crate) fn rust_type(p: &Parameter) -> Result<String, GenerationError> {
    Ok(match p.schema["type"].as_str() {
        Some("string") => "String",
        Some("boolean") => "bool",
        Some("integer") if p.schema["format"] == "int32" => "i32",
        Some("integer") => "i64",
        Some("number") => "serde_json::Number",
        Some("array") => "Vec<String>",
        _ => {
            return Err(GenerationError(format!(
                "unsupported parameter {}",
                p.wire_name
            )));
        }
    }
    .into())
}
fn normalize_schema(schema: &mut Value) {
    let Some(node) = schema.as_object_mut() else {
        return;
    };
    node.remove("default");
    if node.get("type").and_then(Value::as_str) == Some("string") {
        node.remove("enum");
    }
    for key in [
        "properties",
        "additionalProperties",
        "items",
        "allOf",
        "anyOf",
        "oneOf",
        "not",
    ] {
        if let Some(value) = node.get_mut(key) {
            if key == "properties" {
                for child in value.as_object_mut().into_iter().flatten().map(|(_, v)| v) {
                    normalize_schema(child)
                }
            } else if let Some(children) = value.as_array_mut() {
                for child in children {
                    normalize_schema(child)
                }
            } else {
                normalize_schema(value)
            }
        }
    }
}
fn convert(spec: &Value) -> Result<Value, GenerationError> {
    let script =
        std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../../tools/openapi/convert.cjs");
    let mut child = Command::new("node")
        .arg(script)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .map_err(|e| {
            GenerationError(format!(
                "OpenAPI conversion requires Node and npm ci --prefix tools/openapi: {e}"
            ))
        })?;
    child
        .stdin
        .take()
        .unwrap()
        .write_all(&serde_json::to_vec(spec)?)?;
    let output = child.wait_with_output()?;
    if !output.status.success() {
        return Err(GenerationError(format!(
            "OpenAPI conversion failed: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        )));
    }
    Ok(serde_json::from_slice(&output.stdout)?)
}
pub fn facade(
    client: &RenderedClient,
    pagination: &[&crate::pagination::Resolved],
) -> Result<String, GenerationError> {
    crate::facades::rust(client, pagination)
}
pub(crate) fn metadata(client: &RenderedClient) -> Result<String, GenerationError> {
    let cases = client.operations.iter().map(|op| {
        let name = &op.name;
        let names = op.csv_query_names();
        quote::quote!(#name=>&[#(#names),*],)
    });
    crate::format_tokens(
        quote::quote!(pub(crate) fn csv_query_names(operation:&str)->&'static [&'static str] {match operation {#(#cases)* _=>&[]}}),
    )
}
