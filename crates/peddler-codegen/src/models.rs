use crate::GenerationError;
use serde_json::{Map, Value, json};
use std::collections::{BTreeMap, BTreeSet};

/// Normalize only schemas. Example data and property-name maps are never schemas.
pub fn normalize_definitions(spec: &Value) -> Result<Value, GenerationError> {
    let definitions = spec
        .get("definitions")
        .and_then(Value::as_object)
        .ok_or_else(|| GenerationError("missing definitions object".into()))?;
    let mut normalized = definitions.clone();
    for schema in normalized.values_mut() {
        normalize_schema(schema, definitions)?;
    }
    Ok(Value::Object(normalized))
}

fn normalize_schema(
    schema: &mut Value,
    definitions: &Map<String, Value>,
) -> Result<(), GenerationError> {
    let Some(node) = schema.as_object_mut() else {
        return Ok(());
    };
    node.remove("default");
    for (exclusive, bound) in [
        ("exclusiveMinimum", "minimum"),
        ("exclusiveMaximum", "maximum"),
    ] {
        if let Some(enabled) = node.get(exclusive).and_then(Value::as_bool) {
            node.remove(exclusive);
            if enabled {
                let value = node.remove(bound).filter(Value::is_number).ok_or_else(|| {
                    GenerationError(format!("{exclusive} requires a numeric {bound}"))
                })?;
                node.insert(exclusive.into(), value);
            }
        }
    }
    if node.get("type").and_then(Value::as_str) == Some("string")
        && let Some(values) = node.remove("enum")
    {
        let known = values
            .as_array()
            .ok_or_else(|| GenerationError("enum must be an array".into()))?
            .iter()
            .map(Value::to_string)
            .collect::<Vec<_>>()
            .join(", ");
        let description = node
            .get("description")
            .and_then(Value::as_str)
            .unwrap_or("");
        let documentation = format!(
            "{description}\n\nKnown values: {known}. Other values may be returned by Amazon."
        );
        node.insert(
            "description".into(),
            Value::String(documentation.trim().into()),
        );
    }
    let required: BTreeSet<String> = node
        .get("required")
        .and_then(Value::as_array)
        .into_iter()
        .flatten()
        .filter_map(Value::as_str)
        .map(str::to_owned)
        .collect();
    if let Some(properties) = node.get_mut("properties").and_then(Value::as_object_mut) {
        for (name, property) in properties {
            let optional_array =
                !required.contains(name) && is_array(property, definitions, &mut BTreeSet::new());
            normalize_schema(property, definitions)?;
            if optional_array {
                let property = property
                    .as_object_mut()
                    .ok_or_else(|| GenerationError("array schema must be an object".into()))?;
                if let Some(reference) = property.remove("$ref") {
                    property.insert("anyOf".into(), json!([{"$ref":reference}, {"type":"null"}]));
                } else {
                    property.insert("type".into(), json!(["array", "null"]));
                }
            }
        }
    }
    for key in ["additionalProperties", "items", "not"] {
        if let Some(child) = node.get_mut(key) {
            if let Some(children) = child.as_array_mut() {
                for child in children {
                    normalize_schema(child, definitions)?;
                }
            } else {
                normalize_schema(child, definitions)?;
            }
        }
    }
    for key in ["allOf", "anyOf", "oneOf"] {
        if let Some(children) = node.get_mut(key).and_then(Value::as_array_mut) {
            for child in children {
                normalize_schema(child, definitions)?;
            }
        }
    }
    for key in ["definitions", "patternProperties"] {
        if let Some(children) = node.get_mut(key).and_then(Value::as_object_mut) {
            for child in children.values_mut() {
                normalize_schema(child, definitions)?;
            }
        }
    }
    Ok(())
}

fn is_array(schema: &Value, definitions: &Map<String, Value>, seen: &mut BTreeSet<String>) -> bool {
    if schema.get("type").and_then(Value::as_str) == Some("array") {
        return true;
    }
    let Some(name) = schema
        .get("$ref")
        .and_then(Value::as_str)
        .and_then(|reference| reference.strip_prefix("#/definitions/"))
    else {
        return false;
    };
    if !seen.insert(name.into()) {
        return false;
    }
    definitions
        .get(name)
        .is_some_and(|schema| is_array(schema, definitions, seen))
}

pub(crate) fn render(definitions: Value) -> Result<String, GenerationError> {
    let schemas: BTreeMap<String, schemars::schema::Schema> = serde_json::from_value(definitions)?;
    let mut types = typify::TypeSpace::new(&typify::TypeSpaceSettings::default());
    types
        .add_ref_types(schemas)
        .map_err(|error| GenerationError(error.to_string()))?;
    super::format_tokens(types.to_stream())
}
