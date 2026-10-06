mod support;

use peddler::{
    Client, Error,
    apis::{
        self,
        catalog_items_2022_04_01::{GetCatalogItemParams, get_catalog_item},
        listings_items_2021_08_01::{PatchListingsItemParams, models, patch_listings_item},
    },
};
use serde_json::{Value, json};
use std::time::Duration;
use support::{Reply, Server, http, replies};
use tokio::net::TcpListener;

const TOKEN: &str = "private-operation-token";
/// A client whose one request gets this status and body, with a request id and a
/// repeated header.
async fn server(status: u16, body: &[u8]) -> (Client, Server) {
    let server = replies(vec![http(
        status,
        "Content-Type: application/json\r\nX-Amzn-RequestId: operation-id\r\nX-Repeat: first\r\nX-Repeat: second\r\n",
        body,
    )])
    .await;
    (Client::new(&server.url, TOKEN).unwrap(), server)
}
/// The one request the server received.
fn received(server: &Server) -> String {
    server.requests().remove(0)
}
fn target(request: &str) -> reqwest::Url {
    let line = request.lines().next().unwrap();
    reqwest::Url::parse(&format!(
        "http://localhost{}",
        line.split(' ').nth(1).unwrap()
    ))
    .unwrap()
}
fn query(request: &str) -> Vec<(String, String)> {
    target(request)
        .query_pairs()
        .map(|(k, v)| (k.into_owned(), v.into_owned()))
        .collect()
}
fn body(request: &str) -> Value {
    serde_json::from_str(request.split_once("\r\n\r\n").unwrap().1).unwrap()
}
fn catalog() -> GetCatalogItemParams {
    GetCatalogItemParams::new("188864544X".into(), vec!["A1F83G8C2ARO7P".into()])
}
fn patch(value: Value) -> PatchListingsItemParams {
    PatchListingsItemParams::new(
        "A34PPN1ZLYCOGT".into(),
        "SKU123".into(),
        vec!["A1F83G8C2ARO7P".into()],
        value,
    )
}

#[tokio::test]
async fn defaults_explicit_and_null_queries_use_one_csv_value() {
    for (included, expected) in [
        (Some(json!(["images", "FUTURE"])), Some("images,FUTURE")),
        (None, Some("summaries")),
        (Some(Value::Null), None),
    ] {
        let (client, api) = server(200, b"{}").await;
        let mut arguments = json!({"asin":"X","marketplace_ids":["UK","DE"]});
        if let Some(value) = included {
            arguments["included_data"] = value;
        }
        apis::execute(
            &client,
            "catalog_items_2022_04_01.get_catalog_item",
            &arguments.to_string(),
        )
        .await
        .unwrap();
        let pairs = query(&received(&api));
        let values = |key: &str| {
            pairs
                .iter()
                .filter(|(k, _)| k == key)
                .map(|(_, v)| v.as_str())
                .collect::<Vec<_>>()
        };
        assert_eq!(values("marketplaceIds"), ["UK,DE"]);
        assert_eq!(values("includedData"), Vec::from_iter(expected));
    }
}
#[tokio::test]
async fn path_segments_escape_reserved_unicode_and_percent_once() {
    let (client, api) = server(200, b"{}").await;
    let mut params = patch(json!({}));
    params.sku = "a/b +%?雪".into();
    patch_listings_item(&client, params).await.unwrap();
    assert_eq!(
        target(&received(&api)).path(),
        "/listings/2021-08-01/items/A34PPN1ZLYCOGT/a%2Fb%20%2B%25%3F%E9%9B%AA"
    );
}
#[tokio::test]
async fn dynamic_body_preserves_unknown_members_empty_arrays_and_null() {
    let value = json!({"productType":"PRODUCT","patches":[],"future":{"empty":[],"null":null}});
    let (client, api) = server(200, b"{}").await;
    patch_listings_item(&client, patch(value.clone()))
        .await
        .unwrap();
    assert_eq!(body(&received(&api)), value);
    let typed: models::ListingsItemPatchRequest =
        serde_json::from_value(json!({"productType":"PRODUCT","patches":[]})).unwrap();
    let (client, api) = server(200, b"{}").await;
    let params =
        PatchListingsItemParams::new("seller".into(), "sku".into(), vec!["UK".into()], typed);
    patch_listings_item(&client, params).await.unwrap();
    assert_eq!(
        body(&received(&api)),
        json!({"productType":"PRODUCT","patches":[]})
    );
}
#[tokio::test]
async fn dispatcher_preserves_dynamic_number_tokens_on_the_wire() {
    let arguments = r#"{"seller_id":"seller","sku":"sku","marketplace_ids":["UK"],"body":{"values":[18446744073709551617,-9223372036854775809,0.12345678901234567890123456789]}}"#;
    let (client, api) = server(200, b"{}").await;
    apis::execute(
        &client,
        "listings_items_2021_08_01.patch_listings_item",
        arguments,
    )
    .await
    .unwrap();
    assert_eq!(
        received(&api).split_once("\r\n\r\n").unwrap().1,
        r#"{"values":[18446744073709551617,-9223372036854775809,0.12345678901234567890123456789]}"#
    );
}
#[tokio::test]
async fn all_http_statuses_and_malformed_json_remain_raw_responses() {
    for (status, raw) in [(200, b"not JSON".as_slice()), (404, b"broken error")] {
        let (client, _) = server(status, raw).await;
        let response = get_catalog_item(&client, catalog()).await.unwrap();
        assert_eq!(response.raw.status, status);
        assert_eq!(response.raw.body, raw);
        assert!(response.json().is_err());
        assert!(
            response
                .raw
                .headers
                .contains(&("x-amzn-requestid".into(), "operation-id".into()))
        );
        assert_eq!(
            response
                .raw
                .headers
                .iter()
                .filter(|(k, _)| k == "x-repeat")
                .count(),
            2
        );
        assert_eq!(response.into_raw().body, raw);
    }
    let (client, _) = server(
        200,
        br#"{"sku":"s","submissionId":"i","status":"FUTURE","issues":[]}"#,
    )
    .await;
    assert_eq!(
        patch_listings_item(&client, patch(json!({})))
            .await
            .unwrap()
            .json()
            .unwrap()
            .status,
        "FUTURE"
    );
}
#[tokio::test]
async fn refuses_what_it_cannot_send_before_network_without_echoing_secrets() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let client = Client::new(&format!("http://{}", listener.local_addr().unwrap()), TOKEN).unwrap();
    // A dot segment would be resolved away and reach another resource.
    for value in [".", ".."] {
        let mut p = catalog();
        p.asin = value.into();
        assert_eq!(
            get_catalog_item(&client, p).await.unwrap_err(),
            Error::InvalidRequest
        );
        let mut p = patch(json!({}));
        p.seller_id = value.into();
        assert_eq!(
            patch_listings_item(&client, p).await.unwrap_err(),
            Error::InvalidRequest
        );
        let mut p = patch(json!({}));
        p.sku = value.into();
        assert_eq!(
            patch_listings_item(&client, p).await.unwrap_err(),
            Error::InvalidRequest
        );
    }
    for (operation, args) in [
        ("unknown", "private-secret"),
        ("catalog_items_2022_04_01.get_catalog_item", "not JSON"),
        (
            "catalog_items_2022_04_01.get_catalog_item",
            r#"{"asin":"private-secret","marketplace_ids":["UK"],"typo":true}"#,
        ),
        // A value of the wrong type, and a header value with a line break
        (
            "shipping_v2.get_shipment_documents",
            r#"{"shipment_id":"s","package_client_reference_id":"p","dpi":"private-secret"}"#,
        ),
        (
            "shipping_v2.link_carrier_account",
            r#"{"carrier_id":"c","body":{},"x_amzn_shipping_business_id":"private-secret\r\nbad"}"#,
        ),
    ] {
        let error = apis::execute(&client, operation, args).await.unwrap_err();
        assert_eq!(error, Error::InvalidRequest);
        assert!(!format!("{error:?} {error}").contains("private-secret"));
    }
    assert!(
        tokio::time::timeout(Duration::from_millis(30), listener.accept())
            .await
            .is_err()
    );
}
#[tokio::test]
async fn sends_what_only_amazon_can_judge() {
    for (operation, arguments, expected) in [
        (
            "shipping_v1.retrieve_shipping_label",
            json!({"shipment_id":"s","tracking_id":"","body":{}}),
            "POST /shipping/v1/shipments/s/containers//label HTTP/1.1",
        ),
        (
            "fulfillment_inbound_2024_03_20.list_item_compliance_details",
            json!({"mskus":[],"marketplace_id":"UK"}),
            "GET /inbound/fba/2024-03-20/items/compliance?marketplaceId=UK&mskus= HTTP/1.1",
        ),
        (
            "fulfillment_inbound_v0.get_prep_instructions",
            json!({"ship_to_country_code":"gb","asin_list":["a,b",""]}),
            "GET /fba/inbound/v0/prepInstructions?ASINList=a%2Cb%2C&ShipToCountryCode=gb HTTP/1.1",
        ),
    ] {
        let (client, api) = server(200, b"{}").await;
        apis::execute(&client, operation, &arguments.to_string())
            .await
            .unwrap();
        assert_eq!(received(&api).lines().next().unwrap(), expected);
    }
}
#[tokio::test]
async fn configured_timeout_covers_generated_response_body_collection() {
    let server = replies(vec![
        Reply::raw(b"HTTP/1.1 200 OK\r\nContent-Length: 100\r\n\r\nx").held(Duration::from_secs(5)),
    ])
    .await;
    let client = Client::with_timeout(&server.url, TOKEN, Duration::from_millis(40)).unwrap();
    assert_eq!(
        get_catalog_item(&client, catalog()).await.unwrap_err(),
        Error::Timeout
    );
}

#[tokio::test]
async fn expanded_facades_replay_audited_native_protocol_cases() {
    let cases: Value = serde_json::from_str(include_str!(
        "../../../test/fixtures/native/operations/full_cases.json"
    ))
    .unwrap();
    for case in cases.as_array().unwrap() {
        let status = case["status"].as_u64().unwrap() as u16;
        let raw = case["response"].as_str().unwrap().as_bytes();
        let (client, api) = server(status, raw).await;
        let result = apis::execute(
            &client,
            case["operation"].as_str().unwrap(),
            &case["arguments"].to_string(),
        )
        .await
        .unwrap();
        assert_eq!(result.status, status);
        assert_eq!(result.body, raw);
        assert_eq!(
            result
                .headers
                .iter()
                .filter(|(name, _)| name == "x-repeat")
                .count(),
            2
        );
        let req = received(&api);
        let first = req.lines().next().unwrap();
        assert_eq!(
            first.split(' ').next().unwrap(),
            case["method"].as_str().unwrap()
        );
        assert_eq!(target(&req).path(), case["path"].as_str().unwrap());
        let mut actual = query(&req);
        actual.sort();
        let mut expected: Vec<(String, String)> =
            serde_json::from_value(case["query"].clone()).unwrap();
        expected.sort();
        assert_eq!(actual, expected, "{}", case["operation"]);
        let headers = req.to_ascii_lowercase();
        assert!(
            headers.contains("\r\nx-amz-date: "),
            "{}",
            case["operation"]
        );
        if let Some(pairs) = case["headers"].as_array() {
            for pair in pairs {
                assert!(
                    headers.contains(
                        &format!(
                            "{}: {}",
                            pair[0].as_str().unwrap(),
                            pair[1].as_str().unwrap()
                        )
                        .to_ascii_lowercase()
                    )
                )
            }
        }
        if case["body"].is_null() {
            assert!(req.split_once("\r\n\r\n").unwrap().1.is_empty());
            assert!(!headers.contains("content-type: application/json"));
        } else {
            assert_eq!(body(&req), case["body"]);
        }
    }
}

#[tokio::test]
async fn distinct_success_decoders_require_the_matching_status_and_preserve_raw() {
    use apis::fulfillment_outbound_2026_07_04::{CreateOrderParams, create_order};
    let (client, _) = server(202, br#"{"orderId":"o","status":"ACCEPTED"}"#).await;
    let response = create_order(&client, CreateOrderParams::new(json!({})))
        .await
        .unwrap();
    assert_eq!(response.json_202().unwrap().order_id, "o");
    assert!(matches!(
        response.json_200(),
        Err(peddler::DecodeError::UnexpectedStatus {
            expected: 200,
            actual: 202
        })
    ));
    assert_eq!(response.raw.status, 202);
    let (client, _) = server(
        200,
        include_bytes!("../../../test/fixtures/native/operations/create_order_200.json"),
    )
    .await;
    let response = create_order(&client, CreateOrderParams::new(json!({})))
        .await
        .unwrap();
    assert!(response.json_200().is_ok());
    assert!(matches!(
        response.json_202(),
        Err(peddler::DecodeError::UnexpectedStatus {
            expected: 202,
            actual: 200
        })
    ));
}
