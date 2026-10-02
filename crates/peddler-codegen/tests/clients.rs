use peddler_codegen::{clients, manifest::ALL_APIS};
use serde_json::{Value, json};
fn spec() -> Value {
    json!({"swagger":"2.0","produces":["application/json"],"info":{"title":"Synthetic","version":"1"},"paths":{
        "/items/{asin}":{"get":{"operationId":"getItem","parameters":[
            {"name":"asin","in":"path","required":true,"type":"string"},
            {"name":"marketplaceIds","in":"query","required":true,"type":"array","items":{"type":"string"},"collectionFormat":"csv"},
            {"name":"includedData","in":"query","type":"array","items":{"type":"string"},"default":["summaries"]},
            {"name":"mskus","in":"query","type":"array","items":{"type":"string"},"collectionFormat":"multi"},
            {"name":"enabled","in":"query","type":"boolean"},
            {"name":"count","in":"query","type":"integer","format":"int32"},
            {"name":"at","in":"query","type":"string","format":"date-time"},
            {"name":"x-test","in":"header","type":"string"}],
            "responses":{"200":{"description":"ok","schema":{"$ref":"#/definitions/Item"}},"204":{"description":"empty"}}}},
        "/empty":{"post":{"operationId":"empty","parameters":[],"responses":{"200":{"description":"empty"}}}}
    },"definitions":{"Item":{"type":"object","properties":{"asin":{"type":"string"}}}}})
}
#[test]
fn all_operations_keep_per_operation_shapes_and_builder_forwarding() {
    let value = spec();
    let rendered = clients::render(&value, &ALL_APIS[0]).unwrap();
    assert_eq!(rendered.operations.len(), 2);
    assert!(rendered.wire.contains("pub fn empty"));
    assert!(rendered.wire.contains("ResponseValue<ByteStream>"));
    let item = rendered
        .operations
        .iter()
        .find(|op| op.name == "get_item")
        .unwrap();
    assert_eq!(
        item.csv_query_names(),
        vec!["marketplaceIds", "includedData"]
    );
    assert_eq!(item.successes.len(), 2);
    let facade = clients::facade(&rendered, &ALL_APIS[0]).unwrap();
    assert!(facade.contains("pub struct EmptyParams"));
    assert!(facade.contains("pub count: Option<i32>"));
    assert!(facade.contains("pub enabled: Option<bool>"));
    assert!(facade.contains(".x_test("));
    assert!(facade.contains(".run("));
    assert!(facade.contains("json_200"));
    assert_eq!(
        rendered.wire,
        clients::render(&value, &ALL_APIS[0]).unwrap().wire
    );
}
#[test]
fn unsupported_parameters_and_invalid_defaults_fail_before_rendering() {
    let mut value = spec();
    value["paths"]["/items/{asin}"]["get"]["parameters"][1]["collectionFormat"] = json!("ssv");
    assert!(clients::render(&value, &ALL_APIS[0]).is_err());
    let mut value = spec();
    value["paths"]["/items/{asin}"]["get"]["parameters"][2]["default"] = json!(["bad,value"]);
    assert!(clients::render(&value, &ALL_APIS[0]).is_err());
}
#[test]
fn scalar_csv_default_is_normalized_to_its_declared_array_type() {
    let mut value = spec();
    value["paths"]["/items/{asin}"]["get"]["parameters"][2]["default"] = json!("summaries");
    let api = ALL_APIS
        .iter()
        .find(|api| api.module == "catalog_items_2020_12_01")
        .unwrap();
    assert!(clients::render(&value, &ALL_APIS[0]).is_err());
    let rendered = clients::render(&value, api).unwrap();
    let item = rendered
        .operations
        .iter()
        .find(|op| op.name == "get_item")
        .unwrap();
    assert_eq!(item.parameters[2].schema["default"], json!(["summaries"]));
}
#[test]
fn arbitrary_duplicate_operation_ids_fail_generation() {
    let mut value = spec();
    let operation = value["paths"]["/empty"]["post"].clone();
    value["paths"]["/empty"]["put"] = operation;
    let Err(err) = clients::render(&value, &ALL_APIS[0]) else {
        panic!("expected error");
    };
    assert!(err.0.contains("duplicate operationId empty"));
}

#[test]
fn duplicate_methods_on_different_paths_fail_generation() {
    let mut value = spec();
    let operation = value["paths"]["/empty"]["post"].clone();
    value["paths"]["/other"] = json!({"post": operation});
    let Err(err) = clients::render(&value, &ALL_APIS[0]) else {
        panic!("expected error");
    };
    assert!(err.0.contains("duplicate operationId empty"));
}

#[test]
fn shipping_v2_link_carrier_account_put_is_renamed_to_expose_distinct_operations() {
    let mut value = spec();
    let api = ALL_APIS
        .iter()
        .find(|api| api.module == "shipping_v2")
        .unwrap();
    let mut post_op = value["paths"]["/empty"]["post"].clone();
    post_op["operationId"] = json!("linkCarrierAccount");
    let put_op = post_op.clone();
    value["paths"]["/shipping/v2/carrierAccounts"] = json!({
        "post": post_op,
        "put": put_op,
    });
    let rendered = clients::render(&value, api).unwrap();
    assert!(
        rendered
            .operations
            .iter()
            .any(|op| op.name == "link_carrier_account")
    );
    assert!(
        rendered
            .operations
            .iter()
            .any(|op| op.name == "link_carrier_account_put")
    );
    assert!(rendered.wire.contains("pub fn link_carrier_account_put"));
}

#[test]
fn malformed_scalar_defaults_fail_generation_before_runtime_construction() {
    let mut value = spec();
    value["paths"]["/items/{asin}"]["get"]["parameters"][4]["default"] = json!("not-a-boolean");
    assert!(clients::render(&value, &ALL_APIS[0]).is_err());
}
#[test]
fn bodyless_success_status_does_not_offer_json_even_with_an_upstream_schema() {
    let mut value = spec();
    value["paths"]["/empty"]["post"]["responses"] =
        json!({"204":{"description":"bodyless","schema":{"type":"string"}}});
    let rendered = clients::render(&value, &ALL_APIS[0]).unwrap();
    assert_eq!(rendered.operations[0].successes, vec![(204, None)]);
}
