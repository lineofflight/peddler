use peddler_codegen::models::normalize_definitions;
use serde_json::{Value, json};

fn normalize(definitions: Value) -> Value {
    normalize_definitions(&json!({"definitions": definitions})).unwrap()
}

#[test]
fn string_enums_allow_future_values_and_document_known_values() {
    let output = normalize(json!({"Status": {
        "type": "string", "enum": ["ACCEPTED", "INVALID"], "description": "Submission status."
    }}));
    assert!(output["Status"].get("enum").is_none());
    assert_eq!(output["Status"]["type"], "string");
    let description = output["Status"]["description"].as_str().unwrap();
    assert!(description.contains("Submission status."));
    assert!(description.contains("ACCEPTED") && description.contains("INVALID"));
}

#[test]
fn swagger_exclusive_bounds_become_numeric_draft7_bounds() {
    let output = normalize(json!({
        "Exclusive": {"type":"number", "minimum": 1, "exclusiveMinimum": true,
            "maximum": 10, "exclusiveMaximum": true},
        "Inclusive": {"type":"number", "minimum": 0, "exclusiveMinimum": false,
            "maximum": 20, "exclusiveMaximum": false}
    }));
    assert_eq!(output["Exclusive"]["exclusiveMinimum"], 1);
    assert_eq!(output["Exclusive"]["exclusiveMaximum"], 10);
    assert!(output["Exclusive"].get("minimum").is_none());
    assert!(output["Exclusive"].get("maximum").is_none());
    assert_eq!(output["Inclusive"]["minimum"], 0);
    assert_eq!(output["Inclusive"]["maximum"], 20);
    assert!(output["Inclusive"].get("exclusiveMinimum").is_none());
    assert!(output["Inclusive"].get("exclusiveMaximum").is_none());
}

#[test]
fn defaults_are_removed_only_from_schema_nodes() {
    let output = normalize(json!({"Object": {"type":"object", "default":{},
        "properties": {"field": {"type":"string", "default":"hello",
            "example": {"default":"example", "enum":["literal"]}}},
        "example": {"default":"data"},
        "additionalProperties": {"type":"string", "default":"nested"}
    }}));
    assert!(output["Object"].get("default").is_none());
    assert!(
        output["Object"]["properties"]["field"]
            .get("default")
            .is_none()
    );
    assert!(
        output["Object"]["additionalProperties"]
            .get("default")
            .is_none()
    );
    assert_eq!(output["Object"]["example"], json!({"default":"data"}));
    assert_eq!(
        output["Object"]["properties"]["field"]["example"],
        json!({"default":"example", "enum":["literal"]})
    );
}

#[test]
fn optional_arrays_and_array_refs_are_nullable_but_required_arrays_are_not() {
    let output = normalize(json!({
        "Values": {"type":"array", "items":{"type":"string"}},
        "Alias": {"$ref":"#/definitions/Values"},
        "Object": {"type":"object", "required":["required"], "properties":{
            "direct":{"type":"array", "items":{"type":"string"}},
            "referenced":{"$ref":"#/definitions/Values"},
            "aliased":{"$ref":"#/definitions/Alias"},
            "required":{"$ref":"#/definitions/Values"},
            "scalar":{"type":"string"}
        }}
    }));
    let properties = &output["Object"]["properties"];
    assert_eq!(properties["direct"]["type"], json!(["array", "null"]));
    assert_eq!(
        properties["referenced"]["anyOf"],
        json!([
            {"$ref":"#/definitions/Values"}, {"type":"null"}
        ])
    );
    assert_eq!(
        properties["aliased"]["anyOf"],
        json!([
            {"$ref":"#/definitions/Alias"}, {"type":"null"}
        ])
    );
    assert_eq!(
        properties["required"],
        json!({"$ref":"#/definitions/Values"})
    );
    assert_eq!(properties["scalar"], json!({"type":"string"}));
}

#[test]
fn property_names_that_match_schema_keywords_are_preserved() {
    let output = normalize(json!({"Object": {"type":"object", "properties":{
        "enum":{"type":"string", "enum":["KNOWN"]},
        "default":{"type":"array", "default":[], "items":{"type":"string"}},
        "properties":{"type":"string"}
    }}}));
    let properties = output["Object"]["properties"].as_object().unwrap();
    assert_eq!(properties.len(), 3);
    assert!(properties.contains_key("enum") && properties.contains_key("default"));
    assert!(properties["enum"].get("enum").is_none());
    assert!(properties["default"].get("default").is_none());
}
