use base64::{Engine, engine::general_purpose::STANDARD};
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
use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::{TcpListener, TcpStream},
    task::JoinHandle,
};

const TOKEN: &str = "private-operation-token";
async fn read_request(stream: &mut TcpStream) -> Vec<u8> {
    let mut bytes = Vec::new();
    loop {
        let mut chunk = [0; 4096];
        let count = stream.read(&mut chunk).await.unwrap();
        assert!(count > 0);
        bytes.extend_from_slice(&chunk[..count]);
        if let Some(end) = bytes.windows(4).position(|v| v == b"\r\n\r\n") {
            let headers = String::from_utf8_lossy(&bytes[..end]).to_ascii_lowercase();
            let length = headers
                .lines()
                .find_map(|l| l.strip_prefix("content-length: ")?.parse::<usize>().ok())
                .unwrap_or(0);
            if bytes.len() >= end + 4 + length {
                return bytes;
            }
        }
    }
}
fn reply(status: u16, body: &[u8], close: bool) -> Vec<u8> {
    let header = format!(
        "HTTP/1.1 {status} Test\r\nContent-Length: {}\r\nContent-Type: application/json\r\nX-Amzn-RequestId: operation-id\r\nX-Repeat: first\r\nX-Repeat: second\r\n{}\r\n",
        body.len(),
        if close { "Connection: close\r\n" } else { "" }
    );
    [header.as_bytes(), body].concat()
}
async fn server(status: u16, body: &[u8]) -> (Client, JoinHandle<Vec<u8>>) {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let client = Client::new(&format!("http://{}", listener.local_addr().unwrap()), TOKEN).unwrap();
    let response = reply(status, body, true);
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        let request = read_request(&mut stream).await;
        stream.write_all(&response).await.unwrap();
        request
    });
    (client, task)
}
fn target(request: &[u8]) -> reqwest::Url {
    let line = std::str::from_utf8(request)
        .unwrap()
        .lines()
        .next()
        .unwrap();
    reqwest::Url::parse(&format!(
        "http://localhost{}",
        line.split(' ').nth(1).unwrap()
    ))
    .unwrap()
}
fn query(request: &[u8]) -> Vec<(String, String)> {
    target(request)
        .query_pairs()
        .map(|(k, v)| (k.into_owned(), v.into_owned()))
        .collect()
}
fn body(request: &[u8]) -> Value {
    let end = request.windows(4).position(|v| v == b"\r\n\r\n").unwrap() + 4;
    serde_json::from_slice(&request[end..]).unwrap()
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
async fn replays_catalog_and_listings_fixtures_through_named_operations() {
    let fixture: Value = serde_json::from_str(include_str!(
        "../../../test/fixtures/native/catalog_get.json"
    ))
    .unwrap();
    let raw = STANDARD
        .decode(fixture["response"]["body_base64"].as_str().unwrap())
        .unwrap();
    let (client, task) = server(200, &raw).await;
    let mut params = catalog();
    params.included_data = Some(
        fixture["request"]["query"][0][1]
            .as_str()
            .unwrap()
            .split(',')
            .map(str::to_owned)
            .collect(),
    );
    let response = get_catalog_item(&client, params).await.unwrap();
    assert_eq!(response.raw.body, raw);
    assert_eq!(response.json().unwrap().asin.to_string(), "188864544X");
    let req = task.await.unwrap();
    assert_eq!(target(&req).path(), "/catalog/2022-04-01/items/188864544X");
    assert_eq!(
        query(&req),
        serde_json::from_value::<Vec<(String, String)>>(fixture["request"]["query"].clone())
            .unwrap()
    );
    let text = String::from_utf8_lossy(&req).to_ascii_lowercase();
    assert!(text.contains(&format!("x-amz-access-token: {TOKEN}")));
    assert!(text.contains("user-agent: peddler/"));
    assert!(text.contains("accept: application/json"));
    let fixture: Value = serde_json::from_str(include_str!(
        "../../../test/fixtures/native/listings_patch.json"
    ))
    .unwrap();
    let raw = STANDARD
        .decode(fixture["response"]["body_base64"].as_str().unwrap())
        .unwrap();
    let request_body: Value = serde_json::from_slice(
        &STANDARD
            .decode(fixture["request"]["body_base64"].as_str().unwrap())
            .unwrap(),
    )
    .unwrap();
    let (client, task) = server(200, &raw).await;
    let response = patch_listings_item(&client, patch(request_body.clone()))
        .await
        .unwrap();
    assert_eq!(response.raw.body, raw);
    assert_eq!(response.json().unwrap().status, "ACCEPTED");
    let req = task.await.unwrap();
    assert_eq!(
        target(&req).path(),
        "/listings/2021-08-01/items/A34PPN1ZLYCOGT/SKU123"
    );
    assert_eq!(
        query(&req),
        serde_json::from_value::<Vec<(String, String)>>(fixture["request"]["query"].clone())
            .unwrap()
    );
    assert_eq!(body(&req), request_body);
}
#[tokio::test]
async fn defaults_explicit_and_null_queries_use_one_csv_value() {
    for included in [
        Some(vec!["summaries".into()]),
        Some(vec!["images".into(), "FUTURE".into()]),
        None,
    ] {
        let (client, task) = server(200, b"{}").await;
        let mut params = catalog();
        params.marketplace_ids = vec!["UK".into(), "DE".into()];
        params.included_data = included.clone();
        get_catalog_item(&client, params).await.unwrap();
        let req = task.await.unwrap();
        let pairs = query(&req);
        assert_eq!(
            pairs
                .iter()
                .filter(|(k, _)| k == "marketplaceIds")
                .cloned()
                .collect::<Vec<_>>(),
            vec![("marketplaceIds".into(), "UK,DE".into())]
        );
        assert_eq!(
            pairs
                .iter()
                .filter(|(k, _)| k == "includedData")
                .map(|(_, v)| v.clone())
                .collect::<Vec<_>>(),
            included.map(|v| vec![v.join(",")]).unwrap_or_default()
        );
    }
    for (arguments, expected) in [
        (
            json!({"asin":"X","marketplace_ids":["UK"]}),
            Some("summaries"),
        ),
        (
            json!({"asin":"X","marketplace_ids":["UK"],"included_data":null}),
            None,
        ),
    ] {
        let (client, task) = server(200, b"{}").await;
        apis::execute(
            &client,
            "catalog_items_2022_04_01.get_catalog_item",
            &arguments.to_string(),
        )
        .await
        .unwrap();
        assert_eq!(
            query(&task.await.unwrap())
                .iter()
                .find(|(k, _)| k == "includedData")
                .map(|(_, v)| v.as_str()),
            expected
        );
    }
}
#[tokio::test]
async fn path_segments_escape_reserved_unicode_and_percent_once() {
    let (client, task) = server(200, b"{}").await;
    let mut params = patch(json!({}));
    params.sku = "a/b +%?雪".into();
    patch_listings_item(&client, params).await.unwrap();
    assert_eq!(
        target(&task.await.unwrap()).path(),
        "/listings/2021-08-01/items/A34PPN1ZLYCOGT/a%2Fb%20%2B%25%3F%E9%9B%AA"
    );
}
#[tokio::test]
async fn dynamic_body_preserves_unknown_members_empty_arrays_and_null() {
    let value = json!({"productType":"PRODUCT","patches":[],"future":{"empty":[],"null":null}});
    let (client, task) = server(200, b"{}").await;
    patch_listings_item(&client, patch(value.clone()))
        .await
        .unwrap();
    assert_eq!(body(&task.await.unwrap()), value);
    let typed: models::ListingsItemPatchRequest =
        serde_json::from_value(json!({"productType":"PRODUCT","patches":[]})).unwrap();
    let (client, task) = server(200, b"{}").await;
    let params =
        PatchListingsItemParams::new("seller".into(), "sku".into(), vec!["UK".into()], typed);
    patch_listings_item(&client, params).await.unwrap();
    assert_eq!(
        body(&task.await.unwrap()),
        json!({"productType":"PRODUCT","patches":[]})
    );
}
#[tokio::test]
async fn all_http_statuses_and_malformed_json_remain_raw_responses() {
    for (status, raw) in [
        (200, b"not JSON".as_slice()),
        (404, b"broken error"),
        (204, b""),
        (302, b"redirect"),
        (599, b"unknown"),
    ] {
        let (client, task) = server(status, raw).await;
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
        task.await.unwrap();
    }
    let (client, task) = server(
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
    task.await.unwrap();
}
#[tokio::test]
async fn rejects_invalid_arguments_before_network_without_echoing_secrets() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let client = Client::new(&format!("http://{}", listener.local_addr().unwrap()), TOKEN).unwrap();
    for value in ["", ".", ".."] {
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
    for values in [vec![], vec!["".into()], vec!["UK,DE".into()]] {
        let mut p = catalog();
        p.marketplace_ids = values.clone();
        assert_eq!(
            get_catalog_item(&client, p).await.unwrap_err(),
            Error::InvalidRequest
        );
        let mut p = patch(json!({}));
        p.included_data = Some(values);
        assert_eq!(
            patch_listings_item(&client, p).await.unwrap_err(),
            Error::InvalidRequest
        );
    }
    for bad in [Value::Null, json!([]), json!("secret")] {
        assert_eq!(
            patch_listings_item(&client, patch(bad)).await.unwrap_err(),
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
async fn configured_timeout_covers_generated_response_body_collection() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let client = Client::with_timeout(
        &format!("http://{}", listener.local_addr().unwrap()),
        TOKEN,
        Duration::from_millis(40),
    )
    .unwrap();
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        read_request(&mut stream).await;
        stream
            .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 100\r\n\r\nx")
            .await
            .unwrap();
        tokio::time::sleep(Duration::from_secs(5)).await;
    });
    assert_eq!(
        get_catalog_item(&client, catalog()).await.unwrap_err(),
        Error::Timeout
    );
    task.abort();
}
#[tokio::test]
async fn generated_operations_share_the_existing_connection_pool() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let client = Client::new(&format!("http://{}", listener.local_addr().unwrap()), TOKEN).unwrap();
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        for _ in 0..2 {
            read_request(&mut stream).await;
            stream.write_all(&reply(200, b"{}", false)).await.unwrap();
        }
    });
    get_catalog_item(&client, catalog()).await.unwrap();
    tokio::time::timeout(
        Duration::from_secs(1),
        get_catalog_item(&client.clone(), catalog()),
    )
    .await
    .unwrap()
    .unwrap();
    task.await.unwrap();
}

#[tokio::test]
async fn dispatcher_listings_defaults_null_optional_strings_and_dynamic_body_survive() {
    for (included, expected) in [(None, Some("issues")), (Some(Value::Null), None)] {
        let (client, task) = server(200, b"{}").await;
        let mut arguments = json!({"seller_id":"seller","sku":"literal%2F~._-","marketplace_ids":["UK","DE"],"body":{"future":null,"patches":[]},"mode":"FUTURE_MODE","issue_locale":"en_GB"});
        if let Some(value) = included {
            arguments["included_data"] = value;
        }
        apis::execute(
            &client,
            "listings_items_2021_08_01.patch_listings_item",
            &arguments.to_string(),
        )
        .await
        .unwrap();
        let request = task.await.unwrap();
        assert_eq!(
            target(&request).path(),
            "/listings/2021-08-01/items/seller/literal%252F~._-"
        );
        assert_eq!(body(&request), json!({"future":null,"patches":[]}));
        let pairs = query(&request);
        assert_eq!(
            pairs
                .iter()
                .find(|(k, _)| k == "includedData")
                .map(|(_, v)| v.as_str()),
            expected
        );
        assert!(pairs.contains(&("marketplaceIds".into(), "UK,DE".into())));
        assert!(pairs.contains(&("mode".into(), "FUTURE_MODE".into())));
        assert!(pairs.contains(&("issueLocale".into(), "en_GB".into())));
    }
    let (client, task) = server(200, b"{}").await;
    get_catalog_item(&client, catalog()).await.unwrap();
    assert!(query(&task.await.unwrap()).contains(&("includedData".into(), "summaries".into())));
}
