use peddler_codegen::{clients, manifest::APIS};
use serde_json::{Value, json};
fn spec() -> Value {
    json!({"swagger":"2.0","produces":["application/json"],"info":{"title":"Catalog","version":"1"},"paths":{"/items/{asin}":{"get":{"operationId":"getCatalogItem","parameters":[{"name":"asin","in":"path","required":true,"type":"string"},{"name":"marketplaceIds","in":"query","required":true,"type":"array","items":{"type":"string"},"collectionFormat":"csv"},{"name":"includedData","in":"query","type":"array","items":{"type":"string","enum":["summaries"]},"collectionFormat":"csv","default":["summaries"]}],"responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Item"}},"404":{"description":"missing","schema":{"$ref":"#/definitions/Item"}}}},"post":{"operationId":"ignored","responses":{"200":{"description":"ok"}}}},},"definitions":{"Item":{"type":"object","properties":{"asin":{"type":"string"}}}}})
}
#[test]
fn selected_clients_follow_spec_paths_query_names_defaults_and_response_refs() {
    let original = spec();
    let first = clients::render(&original, &APIS[0]).unwrap();
    let mut changed = original.clone();
    let mut operation = changed["paths"]["/items/{asin}"]["get"].take();
    operation["parameters"][1]["name"] = json!("stores");
    operation["parameters"][2]["default"] = json!(["images", "future"]);
    operation["responses"]["200"]["schema"]["$ref"] = json!("#/definitions/FutureItem");
    changed["definitions"]["FutureItem"] =
        json!({"type":"object","properties":{"future":{"type":"string"}}});
    changed["paths"] = json!({"/changed/{asin}":{"get":operation}});
    let next = clients::render(&changed, &APIS[0]).unwrap();
    assert_ne!(first.wire, next.wire);
    assert!(next.wire.contains("/changed/"));
    assert!(next.wire.contains("\"stores\""));
    assert_eq!(next.csv_query_names, vec!["stores", "includedData"]);
    assert_eq!(
        next.included_data_default,
        Some(vec!["images".into(), "future".into()])
    );
    assert_eq!(next.success_model, "FutureItem");
    assert!(!next.wire.contains("pub fn ignored"));
    assert!(next.wire.contains("crate::Client"));
    assert!(next.wire.contains("ResponseValue<ByteStream>"));
    assert_eq!(
        clients::render(&original, &APIS[0]).unwrap().wire,
        first.wire
    );
}
#[test]
fn unsupported_selected_parameter_shapes_fail_instead_of_guessing() {
    for (field, value) in [
        ("collectionFormat", json!("multi")),
        ("type", json!("integer")),
    ] {
        let mut value_spec = spec();
        value_spec["paths"]["/items/{asin}"]["get"]["parameters"][1][field] = value;
        assert!(clients::render(&value_spec, &APIS[0]).is_err());
    }
    let mut missing = spec();
    missing["paths"] = json!({});
    assert!(clients::render(&missing, &APIS[0]).is_err());
    let mut defaults = spec();
    defaults["paths"]["/items/{asin}"]["get"]["parameters"][2]["default"] = json!(["bad,value"]);
    assert!(clients::render(&defaults, &APIS[0]).is_err());
}
