//! Selected Progenitor wire clients. Swagger conversion is delegated to Node.
use crate::{GenerationError, manifest::ApiSpec};
use serde_json::{Value, json};
use std::{
    io::Write,
    process::{Command, Stdio},
};

pub struct RenderedClient {
    pub wire: String,
    pub csv_query_names: Vec<String>,
    pub included_data_default: Option<Vec<String>>,
    pub success_model: String,
}

pub fn render(spec: &Value, api: &ApiSpec) -> Result<RenderedClient, GenerationError> {
    let mut converted = convert(spec)?;
    let paths = converted["paths"]
        .as_object()
        .ok_or_else(|| GenerationError("missing paths".into()))?;
    let mut selected = Vec::new();
    for (path, methods) in paths {
        for (method, operation) in methods.as_object().into_iter().flatten() {
            if operation["operationId"].as_str() == Some(api.operation) {
                selected.push((
                    path.clone(),
                    method.clone(),
                    operation.clone(),
                    methods.get("parameters").cloned(),
                ));
            }
        }
    }
    if selected.len() != 1 {
        return Err(GenerationError(format!(
            "expected exactly one {} operation",
            api.operation
        )));
    }
    let (path, method, mut operation, path_parameters) = selected.into_iter().next().unwrap();
    if path_parameters.is_some() {
        return Err(GenerationError(
            "selected path-level parameters are unsupported".into(),
        ));
    }
    let mut csv_query_names = Vec::new();
    let mut included_data_default = None;
    for parameter in operation["parameters"]
        .as_array_mut()
        .ok_or_else(|| GenerationError("missing operation parameters".into()))?
    {
        let name = parameter["name"]
            .as_str()
            .ok_or_else(|| GenerationError("missing parameter name".into()))?
            .to_owned();
        let schema = &parameter["schema"];
        match (parameter["in"].as_str(), schema["type"].as_str()) {
            (Some("path"), Some("string")) if parameter["required"] == true => {}
            (Some("query"), Some("string")) => {}
            (Some("query"), Some("array"))
                if schema["items"]["type"] == "string"
                    && parameter["style"] == "form"
                    && parameter["explode"] == false =>
            {
                csv_query_names.push(name.clone());
            }
            _ => {
                return Err(GenerationError(format!(
                    "unsupported selected parameter {name}"
                )));
            }
        }
        if name == "includedData"
            && let Some(default) = schema.get("default")
        {
            let values: Vec<String> = serde_json::from_value(default.clone())?;
            if values.is_empty() || values.iter().any(|v| v.is_empty() || v.contains(',')) {
                return Err(GenerationError("invalid includedData default".into()));
            }
            included_data_default = Some(values);
        }
        normalize_schema(&mut parameter["schema"]);
    }
    let successes: Vec<_> = operation["responses"]
        .as_object()
        .ok_or_else(|| GenerationError("missing responses".into()))?
        .iter()
        .filter(|(status, _)| status.starts_with('2'))
        .collect();
    if successes.len() != 1 {
        return Err(GenerationError(
            "selected operation requires one success response".into(),
        ));
    }
    let success_model = successes[0].1["content"]["application/json"]["schema"]["$ref"]
        .as_str()
        .and_then(|r| r.strip_prefix("#/components/schemas/"))
        .ok_or_else(|| GenerationError("selected success requires a model reference".into()))?
        .to_owned();
    match api.operation {
        "getCatalogItem" if operation.get("requestBody").is_none() => {}
        "patchListingsItem"
            if operation["requestBody"]["required"] == true
                && operation["requestBody"]["content"]["application/json"]["schema"]["$ref"]
                    == "#/components/schemas/ListingsItemPatchRequest" => {}
        _ => return Err(GenerationError("unsupported selected request body".into())),
    }
    operation["x-peddler-raw-response"] = json!(true);
    converted["paths"] = json!({path:{method:operation}});
    let schemas = converted["components"]["schemas"]
        .as_object_mut()
        .ok_or_else(|| GenerationError("missing component schemas".into()))?;
    if !schemas.contains_key(&success_model) {
        return Err(GenerationError("selected success model is missing".into()));
    }
    let mut settings = progenitor::GenerationSettings::default();
    settings
        .with_interface(progenitor::InterfaceStyle::Builder)
        .with_inner_type(quote::quote!(crate::Client));
    for (name, schema) in schemas {
        normalize_schema(schema);
        let replacement =
            if api.operation == "patchListingsItem" && name == "ListingsItemPatchRequest" {
                "serde_json::Value".into()
            } else {
                format!("crate::apis::{}::models::{name}", api.module)
            };
        settings.with_replacement(name, &replacement, std::iter::empty());
    }
    let parsed = serde_json::from_value(converted)?;
    let wire = progenitor::Generator::new(&settings)
        .generate_tokens(&parsed)
        .map_err(|e| GenerationError(e.to_string()))?;
    Ok(RenderedClient {
        wire: crate::format_tokens(wire)?,
        csv_query_names,
        included_data_default,
        success_model,
    })
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
            "OpenAPI conversion failed (run npm ci --prefix tools/openapi): {}",
            String::from_utf8_lossy(&output.stderr).trim()
        )));
    }
    Ok(serde_json::from_slice(&output.stdout)?)
}

// OpenAPI 3.0 schemas retain their dialect. Nullable external models are already
// emitted by Typify; JSON Schema null types must never enter the OpenAPI parser.
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
                if let Some(properties) = value.as_object_mut() {
                    for property in properties.values_mut() {
                        normalize_schema(property);
                    }
                }
            } else if let Some(children) = value.as_array_mut() {
                for child in children {
                    normalize_schema(child);
                }
            } else {
                normalize_schema(value);
            }
        }
    }
}

pub(crate) fn metadata(client: &RenderedClient) -> Result<String, GenerationError> {
    let names = &client.csv_query_names;
    let model = quote::format_ident!("{}", client.success_model);
    let default = match &client.included_data_default {
        Some(values) => quote::quote!(Some(vec![#(#values.to_owned()),*])),
        None => quote::quote!(None),
    };
    crate::format_tokens(quote::quote! {
        pub(crate) type ResponseModel = super::models::#model;
        pub(crate) const CSV_QUERY_NAMES: &[&str]=&[#(#names),*];
        pub(crate) fn included_data_default()->Option<Vec<String>> { #default }
    })
}
