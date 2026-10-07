use peddler_codegen::{clients, facades, manifest::ALL_APIS};
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
fn all_operations_keep_per_operation_shapes_and_build_their_own_request() {
    let value = spec();
    let operations = clients::render(&value, &ALL_APIS[0]).unwrap();
    assert_eq!(operations.len(), 2);
    let item = operations.iter().find(|op| op.name == "get_item").unwrap();
    let csv: Vec<_> = item.parameters.iter().filter(|p| p.csv).collect();
    assert_eq!(
        csv.iter().map(|p| &p.wire_name).collect::<Vec<_>>(),
        ["marketplaceIds", "includedData"]
    );
    assert_eq!(item.successes.len(), 2);
    let facade = facades::rust(&operations, &[]).unwrap();
    assert!(facade.contains("pub struct EmptyParams"));
    assert!(facade.contains("pub count: Option<i32>"));
    assert!(facade.contains("pub enabled: Option<bool>"));
    assert!(facade.contains("json_200"));
    // Values go in name order, then empty arrays in declared order.
    let sent: Vec<_> = facade
        .lines()
        .filter_map(|line| line.trim().strip_prefix("operation::"))
        .collect();
    assert_eq!(
        sent,
        [
            r#"pair(&mut query, "at", params.at.as_ref());"#,
            r#"pair(&mut query, "count", params.count.as_ref());"#,
            r#"pair(&mut query, "enabled", params.enabled.as_ref());"#,
            r#"csv(&mut query, "includedData", params.included_data.as_ref());"#,
            r#"csv(&mut query, "marketplaceIds", Some(&params.marketplace_ids));"#,
            r#"repeated(&mut query, "mskus", params.mskus.as_ref());"#,
            r#"empty(&mut query, "marketplaceIds", Some(&params.marketplace_ids));"#,
            r#"empty(&mut query, "includedData", params.included_data.as_ref());"#,
            r#"empty(&mut query, "mskus", params.mskus.as_ref());"#,
            r#"pair(&mut headers, "x-test", params.x_test.as_ref());"#,
        ]
    );
    assert!(
        facade.contains(r#"path: ["/items/", &operation::last_segment(&params.asin)?].concat()"#)
    );
    assert!(facade.contains(r#"path: "/empty".into()"#));
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
    let operations = clients::render(&value, api).unwrap();
    let item = operations.iter().find(|op| op.name == "get_item").unwrap();
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
    let operations = clients::render(&value, api).unwrap();
    assert!(
        operations
            .iter()
            .any(|op| op.name == "link_carrier_account")
    );
    assert!(
        operations
            .iter()
            .any(|op| op.name == "link_carrier_account_put")
    );
}

#[test]
fn malformed_scalar_defaults_fail_generation_before_runtime_construction() {
    let mut value = spec();
    value["paths"]["/items/{asin}"]["get"]["parameters"][4]["default"] = json!("not-a-boolean");
    assert!(clients::render(&value, &ALL_APIS[0]).is_err());
}
#[test]
fn an_operation_media_type_replaces_the_api_one() {
    let successes = |value: &Value| {
        let operations = clients::render(value, &ALL_APIS[0]).unwrap();
        let item = operations.iter().find(|op| op.name == "get_item");
        item.unwrap().successes.clone()
    };
    let mut value = spec();
    value["paths"]["/items/{asin}"]["get"]["produces"] = json!(["application/pdf"]);
    assert_eq!(successes(&value), vec![(200, None), (204, None)]);
    value["produces"] = json!(["application/pdf"]);
    value["paths"]["/items/{asin}"]["get"]["produces"] = json!(["application/json"]);
    assert_eq!(
        successes(&value),
        vec![(200, Some("super::models::Item".into())), (204, None)]
    );
}
#[test]
fn bodyless_success_status_does_not_offer_json_even_with_an_upstream_schema() {
    let mut value = spec();
    value["paths"]["/empty"]["post"]["responses"] =
        json!({"204":{"description":"bodyless","schema":{"type":"string"}}});
    let operations = clients::render(&value, &ALL_APIS[0]).unwrap();
    assert_eq!(operations[0].successes, vec![(204, None)]);
}

#[test]
fn a_default_on_a_body_fails_generation() {
    for default in [
        json!({"k": "#{exit}"}),
        json!({"#{exit}": 1}),
        json!([{"k": "#{exit}"}]),
        json!(["#{exit}"]),
        json!("#{exit}"),
    ] {
        let mut value = spec();
        value["paths"]["/empty"]["post"]["parameters"] =
            json!([{"name":"payload","in":"body","schema":{"type":"object","default":default}}]);
        let Err(err) = clients::render(&value, &ALL_APIS[0]) else {
            panic!("expected an error for {default}");
        };
        assert!(
            err.0.contains("unsupported default for a body"),
            "{}",
            err.0
        );
    }
}
