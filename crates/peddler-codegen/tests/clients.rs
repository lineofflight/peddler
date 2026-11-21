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
/// 31 operation IDs and many parameter names are shared between APIs, so a refusal
/// says which operation it is in. The caller adds the file.
#[test]
fn a_refusal_names_its_operation() {
    let refusal = |value: &Value| match clients::render(value, &ALL_APIS[0]) {
        Err(error) => error.0,
        Ok(_) => panic!("expected an error"),
    };
    let mut value = spec();
    value["paths"]["/items/{asin}"]["get"]["parameters"][1]["collectionFormat"] = json!("ssv");
    assert_eq!(
        refusal(&value),
        "getItem: unsupported array parameter marketplaceIds"
    );
    let mut value = spec();
    value["paths"]["/empty"]["post"]["parameters"] =
        json!([{"name":"payload","in":"body","schema":{"type":"object","default":{}}}]);
    assert_eq!(refusal(&value), "empty: unsupported default for a body");
    let mut value = spec();
    value["paths"]["/empty"]["post"]["responses"]["200"]["schema"] = json!({"type":"object"});
    assert_eq!(refusal(&value), "empty: unsupported inline success schema");
    let mut value = spec();
    value["paths"]["/empty"]["post"]["parameters"] = json!([{"$ref":"#/parameters/gone"}]);
    assert_eq!(refusal(&value), "empty: missing #/parameters/gone");
    let mut value = spec();
    let operation = value["paths"]["/empty"]["post"].clone();
    value["paths"]["/empty"]["put"] = operation;
    assert_eq!(refusal(&value), "duplicate operationId empty");
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

/// The usage plan tables Amazon writes, as the specs have them.
const TWO_COLUMNS: &str = "Returns an item.\n\n**Usage Plan:**\n\n| Rate (requests per second) | Burst |\n| ---- | ---- |\n| 0.0167 | 20 |\n\nThe `x-amzn-RateLimit-Limit` response header returns the usage plan rate limits.";
const THREE_COLUMNS: &str = "Search.\n\n**Usage Plans:**\n\n| Plan type | Rate (requests per second) | Burst |\n| ---- | ---- | ---- |\n|Default| 5 | 10 |\n|Selling partner specific| Variable | Variable |\n\nThe x-amzn-RateLimit-Limit response header returns the usage plan rate limits.";

fn rated(description: &str) -> Result<Option<f64>, String> {
    let mut value = spec();
    value["paths"]["/empty"]["post"]["description"] = json!(description);
    let operations = clients::render(&value, &ALL_APIS[0]).map_err(|error| error.0)?;
    Ok(operations
        .iter()
        .find(|op| op.name == "empty")
        .unwrap()
        .rate)
}

#[test]
fn the_rate_is_the_first_cell_under_its_header_in_the_usage_plan_table() {
    assert_eq!(rated(TWO_COLUMNS), Ok(Some(0.0167)));
    assert_eq!(rated(THREE_COLUMNS), Ok(Some(5.0)));
    // Some specs spell a line break as a backslash and an n.
    assert_eq!(rated(&TWO_COLUMNS.replace('\n', "\\n")), Ok(Some(0.0167)));
    for (written, rate) in [(".5", 0.5), ("2.0", 2.0), ("80", 80.0), ("1.133", 1.133)] {
        let description = TWO_COLUMNS.replace("0.0167", written);
        assert_eq!(rated(&description), Ok(Some(rate)), "{written}");
    }
    // A table that ends the description, as Messaging's do.
    let (table, _) = TWO_COLUMNS.split_once("\n\nThe").unwrap();
    assert_eq!(rated(table), Ok(Some(0.0167)));
    // A rate that varies by seller is no rate, and nor is no usage plan.
    for unknown in ["n", "N"] {
        assert_eq!(rated(&TWO_COLUMNS.replace("0.0167", unknown)), Ok(None));
    }
    assert_eq!(rated("Returns an item."), Ok(None));
    assert_eq!(rated(""), Ok(None));
}

#[test]
fn a_usage_plan_whose_rate_cannot_be_read_fails_generation() {
    for (description, error) in [
        (
            "**Usage Plan:** 1 request per second.".to_owned(),
            "empty: usage plan without a rate table",
        ),
        (
            TWO_COLUMNS.replace("| ---- | ---- |\n", ""),
            "empty: usage plan without a rate table",
        ),
        (
            TWO_COLUMNS.replace("0.0167", "varies"),
            "empty: unsupported rate \"varies\"",
        ),
        (
            TWO_COLUMNS.replace("0.0167", "0"),
            "empty: unsupported rate \"0\"",
        ),
        (
            TWO_COLUMNS.replace("0.0167", "-1"),
            "empty: unsupported rate \"-1\"",
        ),
        (
            TWO_COLUMNS.replace("0.0167", "inf"),
            "empty: unsupported rate \"inf\"",
        ),
    ] {
        assert_eq!(rated(&description), Err(error.to_owned()), "{description}");
    }
}

/// Ways Amazon could rewrite a usage plan. None may pass for a rate in requests per
/// second, or for no rate at all.
#[test]
fn a_usage_plan_in_another_form_fails_generation_and_is_never_misread() {
    let unread = "empty: usage plan without a rate table";
    let table = "| Rate (requests per second) | Burst |\n| ---- | ---- |\n| 5 | 10 |";
    for (description, error) in [
        // Another unit: 5 a minute must not be read as 5 a second.
        (
            TWO_COLUMNS.replace("requests per second", "requests per minute"),
            unread,
        ),
        // The heading and the header change together.
        (
            "**Limits:**\n\n| Requests a second | Burst |\n| ---- | ---- |\n| 5 | 10 |".to_owned(),
            unread,
        ),
        // A unit in the cell, and another table later: the burst must not be the rate.
        (
            format!(
                "{}\n\n| a | b |",
                TWO_COLUMNS.replace("0.0167", "5 per second")
            ),
            "empty: unsupported rate \"5 per second\"",
        ),
        // The columns change places, or another comes between or after them.
        (
            table.replace(
                "Rate (requests per second) | Burst",
                "Burst | Rate (requests per second)",
            ),
            unread,
        ),
        (
            table
                .replace("| Burst |", "| Unit | Burst |")
                .replace("| ---- |\n", "| ---- | ---- |\n")
                .replace("| 5 |", "| 5 | second |"),
            unread,
        ),
        (
            THREE_COLUMNS
                .replace("| Plan type |", "| Plan type | Region |")
                .replace("| ---- | ---- | ---- |", "| ---- | ---- | ---- | ---- |")
                .replace("|Default|", "|Default| EU |"),
            unread,
        ),
        // A row that isn't the header's width, and a rule that isn't one of dashes.
        (table.replace("| 5 | 10 |", "| 5 |"), unread),
        (table.replace("| ---- | ---- |", "| :--- | :--- |"), unread),
        (
            table.replace("| ---- | ---- |\n", "\n| ---- | ---- |\n"),
            unread,
        ),
        // No table at all, with either word in the text.
        ("Allows a burst of 10 requests.".to_owned(), unread),
        ("See the usage plan of your account.".to_owned(), unread),
        ("USAGE PLANS vary.".to_owned(), unread),
    ] {
        assert_eq!(rated(&description), Err(error.to_owned()), "{description}");
    }
    assert_eq!(rated(table), Ok(Some(5.0)));
}

#[test]
fn an_operation_hands_its_rate_to_the_client() {
    let mut value = spec();
    value["paths"]["/items/{asin}"]["get"]["description"] = json!(TWO_COLUMNS);
    let operations = clients::render(&value, &ALL_APIS[0]).unwrap();
    let facade = facades::rust(&operations, &[]).unwrap();
    let calls: Vec<_> = facade.split(".execute_json(").skip(1).collect();
    assert_eq!(calls.len(), 2);
    for (call, rate) in calls.iter().zip(["None", "Some(0.0167)"]) {
        let (arguments, _) = call.split_once(".await?").unwrap();
        let arguments = arguments.trim_end().trim_end_matches(')').trim_end();
        assert!(
            arguments.trim_end_matches(',').ends_with(rate),
            "{arguments}"
        );
    }
}
