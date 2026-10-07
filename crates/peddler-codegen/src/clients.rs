//! Every operation of an API and its parameters, read from Amazon's Swagger 2 spec.
use crate::{GenerationError, manifest::ModelSpec};
use heck::{ToPascalCase, ToSnakeCase};
use serde_json::{Map, Value, json};

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
    /// Its place among the spec's parameters. `Operation::parameters` puts a body last.
    pub position: usize,
    pub location: String,
    pub required: bool,
    pub schema: Value,
    pub csv: bool,
}
impl Operation {
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

const METHODS: [&str; 7] = ["get", "post", "put", "patch", "delete", "head", "options"];
/// What the generator reads of a parameter. Swagger 2 keeps these on the parameter
/// itself. Its constraints are left out: Amazon checks them.
const SCHEMA_KEYS: [&str; 4] = ["type", "format", "enum", "default"];

pub fn render(spec: &Value, api: &ModelSpec) -> Result<Vec<Operation>, GenerationError> {
    let paths = spec["paths"]
        .as_object()
        .ok_or_else(|| GenerationError("missing paths".into()))?;
    let mut operations = Vec::new();
    let mut seen = std::collections::BTreeSet::new();
    for (path, methods) in paths {
        let shared = methods
            .get("parameters")
            .and_then(Value::as_array)
            .cloned()
            .unwrap_or_default();
        for (method, operation) in methods.as_object().into_iter().flatten() {
            if !METHODS.contains(&method.as_str()) {
                continue;
            }
            let Some(id) = operation["operationId"].as_str() else {
                continue;
            };
            // Amazon gives Shipping v2's POST and PUT of a carrier account the same ID.
            let wire_id =
                if api.module == "shipping_v2" && id == "linkCarrierAccount" && method == "put" {
                    format!("{id}_{method}")
                } else {
                    id.to_owned()
                };
            if !seen.insert(wire_id.clone()) {
                return Err(GenerationError(format!(
                    "{}: duplicate operationId {id}",
                    api.module
                )));
            }
            operations.push(Operation {
                name: snake(&wire_id),
                id: id.to_owned(),
                method: method.to_ascii_uppercase(),
                path: path.clone(),
                parameters: parameters(spec, api, &shared, operation, id)?,
                successes: successes(spec, operation, id)?,
            });
        }
    }
    operations.sort_by(|a, b| a.name.cmp(&b.name));
    Ok(operations)
}
/// An operation's parameters: its path's, then its own, with a body last.
fn parameters(
    spec: &Value,
    api: &ModelSpec,
    shared: &[Value],
    operation: &Value,
    id: &str,
) -> Result<Vec<Parameter>, GenerationError> {
    let mut declared = shared.to_vec();
    for parameter in operation["parameters"].as_array().into_iter().flatten() {
        let resolved = resolve(parameter, spec)?;
        declared.retain(|p| !(p["name"] == resolved["name"] && p["in"] == resolved["in"]));
        declared.push(resolved.clone());
    }
    let mut parameters = Vec::new();
    let mut body = None;
    for (position, value) in declared.iter().enumerate() {
        let value = resolve(value, spec)?;
        if value["in"] == "body" {
            body = Some(body_parameter(spec, value, position, id)?);
        } else {
            parameters.push(parameter(api, value, position)?);
        }
    }
    parameters.extend(body);
    Ok(parameters)
}
fn wire_name(value: &Value) -> Result<String, GenerationError> {
    let name = value["name"].as_str();
    Ok(name
        .ok_or_else(|| GenerationError("missing parameter name".into()))?
        .to_owned())
}
fn body_parameter(
    spec: &Value,
    value: &Value,
    position: usize,
    id: &str,
) -> Result<Parameter, GenerationError> {
    // Swagger 2 bodies are JSON unless the spec says otherwise.
    let consumes = media_types(spec, value, "consumes");
    if !(consumes.is_empty() || consumes.contains(&"application/json")) {
        return Err(GenerationError(format!("{id}: unsupported request media")));
    }
    // What sits next to a reference is not schema. Shipping v1 keeps examples there.
    let schema = match value["schema"].get("$ref") {
        Some(reference) => json!({"$ref": reference}),
        None => value["schema"].clone(),
    };
    Ok(Parameter {
        name: "body".into(),
        wire_name: wire_name(value)?,
        position,
        location: "body".into(),
        required: value["required"] == true,
        schema,
        csv: false,
    })
}
/// A path, query or header parameter.
fn parameter(
    api: &ModelSpec,
    value: &Value,
    position: usize,
) -> Result<Parameter, GenerationError> {
    let wire_name = wire_name(value)?;
    let location = value["in"].as_str().unwrap_or("").to_owned();
    let required = value["required"] == true;
    let mut schema: Map<String, Value> = SCHEMA_KEYS
        .iter()
        .filter_map(|key| Some(((*key).to_owned(), value.get(key)?.clone())))
        .collect();
    if schema.get("type") == Some(&json!("string"))
        && schema.get("format") == Some(&json!("boolean"))
    {
        schema.insert("type".into(), json!("boolean"));
        if let Some(default) = schema.get("default").and_then(Value::as_str) {
            let default = default
                .parse::<bool>()
                .map_err(|_| GenerationError("invalid boolean default".into()))?;
            schema.insert("default".into(), json!(default));
        }
    }
    let mut schema = Value::Object(schema);
    let array = schema["type"] == "array";
    if array {
        schema["items"] = json!({"type": value["items"]["type"]});
    }
    // Swagger 2 joins an array with commas unless it says otherwise.
    let csv = array && value["collectionFormat"] != "multi";
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
        || (location == "path" && (!required || schema["type"] != "string"))
    {
        return Err(GenerationError(format!(
            "unsupported {location} parameter {wire_name}"
        )));
    }
    if array
        && (location != "query"
            || !["csv", "multi"].contains(&value["collectionFormat"].as_str().unwrap_or("csv"))
            || schema["items"]["type"] != "string")
    {
        return Err(GenerationError(format!(
            "unsupported array parameter {wire_name}"
        )));
    }
    let parameter = Parameter {
        name: snake(&wire_name),
        wire_name,
        position,
        location,
        required,
        schema,
        csv,
    };
    rust_type(&parameter)?;
    validate_default(&parameter)?;
    Ok(parameter)
}
/// An operation's success statuses, each with the model it returns, if it has one.
fn successes(
    spec: &Value,
    operation: &Value,
    id: &str,
) -> Result<Vec<(u16, Option<String>)>, GenerationError> {
    let json = media_types(spec, operation, "produces").contains(&"application/json");
    let mut successes = Vec::new();
    for (status, response) in operation["responses"].as_object().into_iter().flatten() {
        if !status.starts_with('2') {
            continue;
        }
        let status = status
            .parse::<u16>()
            .map_err(|_| GenerationError("success range unsupported".into()))?;
        // Only a JSON response has a model.
        let schema = if json {
            &resolve(response, spec)?["schema"]
        } else {
            &Value::Null
        };
        let model = if matches!(status, 204 | 205) {
            None
        } else if let Some(reference) = schema["$ref"].as_str() {
            let name = reference
                .strip_prefix("#/definitions/")
                .ok_or_else(|| GenerationError("external success schema".into()))?;
            if spec["definitions"].get(name).is_none() {
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
    Ok(successes)
}
/// The media types an operation consumes or produces: its own list, or else the API's.
fn media_types<'a>(spec: &'a Value, operation: &'a Value, key: &str) -> Vec<&'a str> {
    operation
        .get(key)
        .or_else(|| spec.get(key))
        .and_then(Value::as_array)
        .into_iter()
        .flatten()
        .filter_map(Value::as_str)
        .collect()
}
fn resolve<'a>(value: &'a Value, spec: &'a Value) -> Result<&'a Value, GenerationError> {
    if let Some(reference) = value["$ref"].as_str() {
        let pointer = reference
            .strip_prefix('#')
            .ok_or_else(|| GenerationError("external reference".into()))?;
        spec.pointer(pointer)
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
