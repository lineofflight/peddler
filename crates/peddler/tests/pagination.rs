mod support;

use futures_util::StreamExt;
use peddler::{
    Client, ClientConfig,
    apis::{self, orders_v0},
    pagination::{Continuation, Pagination, PaginationError, pages},
};
use serde_json::{Value, json};
use std::time::Duration;
use support::{Server, http};

const CASES: &str = include_str!("../../../test/fixtures/native/pagination/cases.json");
const SECRET: &str = "private-pagination-token";

struct Recorded {
    method: String,
    path: String,
    query: Vec<(String, String)>,
    body: Option<Value>,
    headers: String,
}

/// Serves `replies` in order, one request per connection. Requests beyond the
/// script get a 500 so that an unexpected extra fetch is both visible and failing.
async fn serve(replies: Vec<(u16, String)>) -> Server {
    support::serve(move |index, _, _| {
        let (status, body) = replies
            .get(index)
            .cloned()
            .unwrap_or((500, "unexpected extra request".into()));
        http(status, "", body.as_bytes())
    })
    .await
}

/// The requests so far.
fn recorded(server: &Server) -> Vec<Recorded> {
    let parse = |request: &String| {
        let (head, payload) = request.split_once("\r\n\r\n").unwrap();
        let mut parts = head.lines().next().unwrap().split(' ');
        let method = parts.next().unwrap().to_owned();
        let target = reqwest::Url::parse(&format!("http://h{}", parts.next().unwrap())).unwrap();
        Recorded {
            method,
            path: target.path().to_owned(),
            query: target
                .query_pairs()
                .map(|(k, v)| (k.into_owned(), v.into_owned()))
                .collect(),
            body: serde_json::from_str(payload).ok(),
            headers: head.to_ascii_lowercase(),
        }
    };
    server.requests().iter().map(parse).collect()
}

fn client(url: &str) -> Client {
    Client::new(url, SECRET).unwrap()
}

fn strings(value: &Value) -> Vec<String> {
    value
        .as_array()
        .into_iter()
        .flatten()
        .map(|v| v.as_str().unwrap().to_owned())
        .collect()
}

fn mapping(value: &Value) -> Pagination {
    if let Some(key) = value.as_str() {
        return apis::pagination::mapping(key).unwrap_or_else(|| panic!("no mapping for {key}"));
    }
    let c = &value["continuation"];
    Pagination {
        operation: value["operation"].as_str().unwrap().into(),
        input: value["input"].as_str().unwrap().into(),
        output: value["output"].as_str().unwrap().into(),
        continuation: Continuation {
            operation: c["operation"].as_str().map(str::to_owned),
            keep: c.get("keep").map(strings),
            drop: strings(&c["drop"]),
            set: c["set"]
                .as_object()
                .into_iter()
                .flatten()
                .map(|(k, v)| (k.clone(), v.clone()))
                .collect(),
        },
    }
}

fn error_name(error: &PaginationError) -> &'static str {
    match error {
        PaginationError::RepeatedToken => "repeated_token",
        PaginationError::InvalidToken => "invalid_token",
        PaginationError::MalformedResponse => "malformed_response",
        other => panic!("unexpected {other:?}"),
    }
}

fn sorted(mut pairs: Vec<(String, String)>) -> Vec<(String, String)> {
    pairs.sort();
    pairs
}

#[tokio::test]
async fn shared_cases_replay_through_the_generated_dispatcher() {
    let cases: Vec<Value> = serde_json::from_str(CASES).unwrap();
    assert!(!cases.is_empty());
    for case in cases {
        let name = case["name"].as_str().unwrap();
        let replies = case["responses"]
            .as_array()
            .unwrap()
            .iter()
            .map(|r| {
                (
                    r["status"].as_u64().unwrap() as u16,
                    r["body"].as_str().unwrap().to_owned(),
                )
            })
            .collect();
        let server = serve(replies).await;
        let arguments = case["arguments"].clone();
        let before = arguments.clone();
        let http = client(&server.url);
        let stream = pages(&http, mapping(&case["pagination"]), &arguments);
        let items: Vec<_> = stream.collect().await;
        let mut statuses = Vec::new();
        let mut error = None;
        for item in &items {
            match item {
                Ok(page) => statuses.push(page.status),
                Err(e) => {
                    assert!(error.is_none(), "{name}: more than one error");
                    error = Some(error_name(e));
                    for text in [format!("{e}"), format!("{e:?}")] {
                        assert!(!text.contains(SECRET) && !text.contains("SECRET"), "{name}");
                    }
                }
            }
        }
        assert_eq!(
            statuses,
            case["statuses"]
                .as_array()
                .unwrap()
                .iter()
                .map(|s| s.as_u64().unwrap() as u16)
                .collect::<Vec<_>>(),
            "{name}"
        );
        assert_eq!(error, case["error"].as_str(), "{name}");
        if error.is_some() {
            assert!(
                matches!(items.last(), Some(Err(_))),
                "{name}: error is last"
            );
        }
        let expected = case["requests"].as_array().unwrap();
        let recorded = recorded(&server);
        assert_eq!(recorded.len(), expected.len(), "{name}: request count");
        for (got, want) in recorded.iter().zip(expected) {
            assert!(
                got.headers.contains("\naccept: application/json"),
                "{name}: accept header"
            );
            assert_eq!(got.method, want["method"].as_str().unwrap(), "{name}");
            assert_eq!(got.path, want["path"].as_str().unwrap(), "{name}");
            let query: Vec<(String, String)> = want["query"]
                .as_array()
                .unwrap()
                .iter()
                .map(|p| (p[0].as_str().unwrap().into(), p[1].as_str().unwrap().into()))
                .collect();
            assert_eq!(sorted(got.query.clone()), sorted(query), "{name}");
            assert_eq!(
                got.body.as_ref().unwrap_or(&Value::Null),
                &want["body"],
                "{name}"
            );
        }
        assert_eq!(arguments, before, "{name}: caller input unchanged");
    }
}

#[tokio::test]
async fn typed_convenience_serializes_params_and_stays_lazy() {
    let server = serve(vec![
        (200, r#"{"payload":{"NextToken":"A"}}"#.into()),
        (200, "{}".into()),
    ])
    .await;
    let mut params = orders_v0::GetOrdersParams::new(vec!["ATVPDKIKX0DER".into()]);
    params.created_after = Some("2026-01-01T00:00:00Z".into());
    let http = client(&server.url);
    let mut stream = orders_v0::get_orders_pages(&http, params);
    tokio::time::sleep(Duration::from_millis(50)).await;
    assert!(recorded(&server).is_empty(), "no network until polled");
    let statuses: Vec<u16> = stream.by_ref().map(|p| p.unwrap().status).collect().await;
    assert_eq!(statuses, [200, 200]);
    let recorded = recorded(&server);
    assert_eq!(
        recorded[1]
            .query
            .iter()
            .filter(|(k, _)| k == "NextToken")
            .count(),
        1
    );
    assert_eq!(
        recorded[1]
            .query
            .iter()
            .filter(|(k, _)| k == "MarketplaceIds")
            .count(),
        1
    );
}

#[tokio::test]
async fn dropping_the_stream_never_fetches_another_page() {
    let server = serve(vec![
        (200, r#"{"payload":{"NextToken":"A"}}"#.into()),
        (200, r#"{"payload":{"NextToken":"B"}}"#.into()),
    ])
    .await;
    let http = client(&server.url);
    let mut stream = pages(
        &http,
        apis::pagination::mapping("orders_v0.get_orders").unwrap(),
        &json!({"marketplace_ids": ["ATVPDKIKX0DER"]}),
    );
    stream.next().await.unwrap().unwrap();
    drop(stream);
    tokio::time::sleep(Duration::from_millis(150)).await;
    assert_eq!(recorded(&server).len(), 1);
}

#[tokio::test]
async fn invalid_arguments_and_mappings_fail_without_a_request() {
    let server = serve(vec![]).await;
    let client = client(&server.url);
    let orders = apis::pagination::mapping("orders_v0.get_orders").unwrap();
    let mut s = pages(&client, orders.clone(), &json!([1]));
    assert_eq!(
        s.next().await.unwrap().unwrap_err(),
        PaginationError::InvalidArguments
    );
    assert!(s.next().await.is_none());
    let mut s = pages(&client, orders.clone(), &json!({"next_token": 5}));
    assert_eq!(
        s.next().await.unwrap().unwrap_err(),
        PaginationError::InvalidArguments
    );
    let mut bad = orders;
    bad.output = "payload".into();
    let mut s = pages(&client, bad, &json!({}));
    assert_eq!(
        s.next().await.unwrap().unwrap_err(),
        PaginationError::InvalidMapping
    );
    assert!(recorded(&server).is_empty());
}

#[tokio::test]
async fn transport_failure_is_a_sanitized_request_error_and_ends_the_stream() {
    let http = Client::new("http://127.0.0.1:1", SECRET).unwrap();
    let mut stream = pages(
        &http,
        apis::pagination::mapping("orders_v0.get_orders").unwrap(),
        &json!({"marketplace_ids": ["ATVPDKIKX0DER"]}),
    );
    let error = stream.next().await.unwrap().unwrap_err();
    assert!(matches!(error, PaginationError::Request(_)));
    assert!(!format!("{error:?}{error}").contains(SECRET));
    assert!(stream.next().await.is_none());
}

#[tokio::test]
async fn the_token_and_retries_apply_to_every_page() {
    let api = serve(vec![
        (503, "busy".into()),
        (200, r#"{"payload":{"NextToken":"A"}}"#.into()),
        (200, r#"{"payload":{"NextToken":"B"}}"#.into()),
        (200, r#"{"payload":{}}"#.into()),
    ])
    .await;
    let mut config = ClientConfig::new(api.url.clone(), "supplied-token");
    config.retry.max_retries = 1;
    let client = Client::with_config(config).unwrap();
    let statuses: Vec<u16> = pages(
        &client,
        apis::pagination::mapping("orders_v0.get_orders").unwrap(),
        &json!({"marketplace_ids": ["ATVPDKIKX0DER"]}),
    )
    .map(|p| p.unwrap().status)
    .collect()
    .await;
    assert_eq!(statuses, [200, 200, 200]);
    let recorded = recorded(&api);
    assert_eq!(recorded.len(), 4, "one retry on the first page");
    assert!(
        recorded
            .iter()
            .all(|r| r.headers.contains("x-amz-access-token: supplied-token"))
    );
}
