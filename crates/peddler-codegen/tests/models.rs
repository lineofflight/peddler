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
fn an_enum_of_strings_without_a_type_is_a_string() {
    let output = normalize(json!({"Option": {"type": "object", "properties": {
        "kind": {"enum": ["DEFAULT"], "description": "The kind."},
        "level": {"enum": [1, 2]},
    }}}));
    let kind = &output["Option"]["properties"]["kind"];
    assert!(kind.get("enum").is_none());
    assert_eq!(kind["type"], "string");
    assert_eq!(
        kind["description"],
        "The kind.\n\nKnown values: `DEFAULT`. Other values may be returned by Amazon."
    );
    // An enum of numbers stays an enum, and its doc says no other value may come.
    let level = &output["Option"]["properties"]["level"];
    assert_eq!(level["enum"], json!([1, 2]));
    assert!(level.get("type").is_none());
    assert!(level.get("description").is_none());
}

#[test]
fn a_string_enum_that_holds_null_lists_its_strings() {
    let output = normalize(json!({"Option": {
        "type": "string", "enum": ["DEFAULT", null], "description": "The kind."
    }}));
    assert!(output["Option"].get("enum").is_none());
    assert_eq!(
        output["Option"]["description"],
        "The kind.\n\nKnown values: `DEFAULT`. Other values may be returned by Amazon."
    );
}

#[test]
fn fields_document_known_values_through_a_ref_and_on_items() {
    let output = normalize(json!({
        "Status": {"type": "string", "enum": ["OPEN", "CLOSED"]},
        "Order": {"type": "object", "properties": {
            "status": {"$ref": "#/definitions/Status", "description": "The status."},
            "programs": {"type": "array", "items": {"type": "string", "enum": ["HAZMAT"]}},
            "listed": {"type": "string", "enum": ["A", "B"], "description": "`A` or `B`."},
            "hostile": {"type": "string", "enum": ["a`b", "\"c\"\n:stopdoc:"]}
        }}
    }));
    let description = |name: &str| output["Order"]["properties"][name]["description"].clone();
    let other = "Other values may be returned by Amazon.";
    assert_eq!(
        description("status"),
        format!("The status.\n\nKnown values: `OPEN`, `CLOSED`. {other}")
    );
    assert_eq!(
        description("programs"),
        format!("Known values: `HAZMAT`. {other}")
    );
    // A description that lists every value keeps its own list.
    assert_eq!(description("listed"), "`A` or `B`.");
    assert_eq!(
        description("hostile"),
        format!("Known values: ``a`b``, `\"c\" :stopdoc:`. {other}")
    );
    assert_eq!(
        output["Status"]["description"],
        format!("Known values: `OPEN`, `CLOSED`. {other}")
    );
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

#[test]
fn noncanonical_numeric_bounds_keep_their_values_for_schemars() {
    let spec: Value = serde_json::from_str(r#"{"definitions":{"Weight":{"type":"number","minimum":11.00,"maximum":100.000,"exclusiveMinimum":false}}}"#).unwrap();
    let output = normalize_definitions(&spec).unwrap();
    let schema: schemars::schema::Schema =
        serde_json::from_value(output["Weight"].clone()).unwrap();
    let schemars::schema::Schema::Object(schema) = schema else {
        panic!("object schema")
    };
    let validation = schema.number.unwrap();
    assert_eq!(validation.minimum, Some(11.0));
    assert_eq!(validation.maximum, Some(100.0));
}

#[test]
fn zero_min_length_is_omitted_but_positive_limits_and_examples_survive() {
    let output = normalize(json!({
        "EmptyAllowed": {"type":"string", "minLength":0, "maxLength":10, "example":{"minLength":0}},
        "Nonempty": {"type":"string", "minLength":1}
    }));
    assert!(output["EmptyAllowed"].get("minLength").is_none());
    assert_eq!(output["EmptyAllowed"]["maxLength"], 10);
    assert_eq!(output["Nonempty"]["minLength"], 1);
    assert_eq!(output["EmptyAllowed"]["example"], json!({"minLength":0}));
}
