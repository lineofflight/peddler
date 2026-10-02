use futures_util::StreamExt;
use peddler::{
    Client, ClientConfig, Response,
    apis::{self, orders_v0},
    auth::Credentials,
    pagination::{Continuation, Pagination, PaginationError, pages},
    policy::RateLimit,
};
use serde_json::{Value, json};
use std::{
    sync::{Arc, Mutex},
    time::{Duration, Instant},
};
use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::TcpListener,
    task::JoinHandle,
};

const CASES: &str = include_str!("../../../test/fixtures/native/pagination/cases.json");
const SECRET: &str = "private-pagination-token";

#[derive(Clone, Debug)]
struct Recorded {
    method: String,
    path: String,
    query: Vec<(String, String)>,
    body: Option<Value>,
    headers: String,
}

struct Server {
    url: String,
    requests: Arc<Mutex<Vec<Recorded>>>,
    task: JoinHandle<()>,
}
impl Drop for Server {
    fn drop(&mut self) {
        self.task.abort();
    }
}
impl Server {
    fn recorded(&self) -> Vec<Recorded> {
        self.requests.lock().unwrap().clone()
    }
}

/// Serves `replies` in order, one request per connection. Requests beyond the
/// script get a 500 so that an unexpected extra fetch is both visible and failing.
async fn serve(replies: Vec<(u16, String)>) -> Server {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let url = format!("http://{}", listener.local_addr().unwrap());
    let requests = Arc::new(Mutex::new(Vec::new()));
    let log = requests.clone();
    let task = tokio::spawn(async move {
        let mut index = 0;
        loop {
            let (mut socket, _) = listener.accept().await.unwrap();
            let mut bytes = Vec::new();
            loop {
                let mut chunk = [0; 4096];
                let count = socket.read(&mut chunk).await.unwrap();
                if count == 0 {
                    break;
                }
                bytes.extend_from_slice(&chunk[..count]);
                if let Some(end) = bytes.windows(4).position(|w| w == b"\r\n\r\n") {
                    let head = String::from_utf8_lossy(&bytes[..end]).to_ascii_lowercase();
                    let length = head
                        .lines()
                        .find_map(|l| l.strip_prefix("content-length: ")?.parse::<usize>().ok())
                        .unwrap_or(0);
                    if bytes.len() >= end + 4 + length {
                        break;
                    }
                }
            }
            let end = bytes.windows(4).position(|w| w == b"\r\n\r\n").unwrap();
            let head = String::from_utf8_lossy(&bytes[..end]).into_owned();
            let line = head.lines().next().unwrap().to_owned();
            let mut parts = line.split(' ');
            let method = parts.next().unwrap().to_owned();
            let target =
                reqwest::Url::parse(&format!("http://h{}", parts.next().unwrap())).unwrap();
            let payload = &bytes[end + 4..];
            log.lock().unwrap().push(Recorded {
                method,
                path: target.path().to_owned(),
                query: target
                    .query_pairs()
                    .map(|(k, v)| (k.into_owned(), v.into_owned()))
                    .collect(),
                body: serde_json::from_slice(payload).ok(),
                headers: head.to_ascii_lowercase(),
            });
            let (status, body) = replies
                .get(index)
                .cloned()
                .unwrap_or((500, "unexpected extra request".into()));
            index += 1;
            let reply = format!(
                "HTTP/1.1 {status} Test\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{body}",
                body.len()
            );
            socket.write_all(reply.as_bytes()).await.unwrap();
        }
    });
    Server {
        url,
        requests,
        task,
    }
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
    assert!(cases.len() >= 20);
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
        let stream = pages(
            &http,
            mapping(&case["pagination"]),
            &arguments,
            case["max_pages"].as_u64().map(|n| n as usize),
        );
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
        let recorded = server.recorded();
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
async fn raw_status_headers_and_binary_body_survive_each_page() {
    let server = serve(vec![
        (200, r#"{"payload":{"NextToken":"A"}}"#.into()),
        (200, "{}".into()),
    ])
    .await;
    let http = client(&server.url);
    let mut stream = pages(
        &http,
        apis::pagination::mapping("orders_v0.get_orders").unwrap(),
        &json!({"marketplace_ids": ["ATVPDKIKX0DER"]}),
        None,
    );
    let first: Response = stream.next().await.unwrap().unwrap();
    assert_eq!(first.status, 200);
    assert_eq!(first.body, br#"{"payload":{"NextToken":"A"}}"#);
    assert!(
        first
            .headers
            .iter()
            .any(|(k, v)| k == "content-length" && v == "29")
    );
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
    let mut stream = orders_v0::get_orders_pages(&http, params, None);
    tokio::time::sleep(Duration::from_millis(50)).await;
    assert!(server.recorded().is_empty(), "no network until polled");
    let statuses: Vec<u16> = stream.by_ref().map(|p| p.unwrap().status).collect().await;
    assert_eq!(statuses, [200, 200]);
    let recorded = server.recorded();
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
        None,
    );
    stream.next().await.unwrap().unwrap();
    drop(stream);
    tokio::time::sleep(Duration::from_millis(150)).await;
    assert_eq!(server.recorded().len(), 1);
}

#[tokio::test]
async fn invalid_arguments_and_mappings_fail_without_a_request() {
    let server = serve(vec![]).await;
    let client = client(&server.url);
    let orders = apis::pagination::mapping("orders_v0.get_orders").unwrap();
    let mut s = pages(&client, orders.clone(), &json!([1]), None);
    assert_eq!(
        s.next().await.unwrap().unwrap_err(),
        PaginationError::InvalidArguments
    );
    assert!(s.next().await.is_none());
    let mut s = pages(&client, orders.clone(), &json!({"next_token": 5}), None);
    assert_eq!(
        s.next().await.unwrap().unwrap_err(),
        PaginationError::InvalidArguments
    );
    let mut bad = orders;
    bad.output = "payload".into();
    let mut s = pages(&client, bad, &json!({}), None);
    assert_eq!(
        s.next().await.unwrap().unwrap_err(),
        PaginationError::InvalidMapping
    );
    assert!(server.recorded().is_empty());
}

#[tokio::test]
async fn transport_failure_is_a_sanitized_request_error_and_ends_the_stream() {
    let http = Client::new("http://127.0.0.1:1", SECRET).unwrap();
    let mut stream = pages(
        &http,
        apis::pagination::mapping("orders_v0.get_orders").unwrap(),
        &json!({"marketplace_ids": ["ATVPDKIKX0DER"]}),
        None,
    );
    let error = stream.next().await.unwrap().unwrap_err();
    assert!(matches!(error, PaginationError::Request(_)));
    assert!(!format!("{error:?}{error}").contains(SECRET));
    assert!(stream.next().await.is_none());
}

#[tokio::test]
async fn auth_retry_and_rate_limit_apply_to_every_page() {
    let lwa = serve(vec![(
        200,
        r#"{"access_token":"managed-token","token_type":"bearer","expires_in":3600}"#.into(),
    )])
    .await;
    let api = serve(vec![
        (503, "busy".into()),
        (200, r#"{"payload":{"NextToken":"A"}}"#.into()),
        (200, r#"{"payload":{"NextToken":"B"}}"#.into()),
        (200, r#"{"payload":{}}"#.into()),
    ])
    .await;
    let mut config = ClientConfig::new(
        api.url.clone(),
        Credentials::RefreshToken {
            client_id: "id".into(),
            client_secret: "secret".into(),
            refresh_token: "refresh".into(),
        },
    );
    config.lwa_endpoint = lwa.url.clone();
    config.policy.retry.max_retries = 1;
    config.policy.retry.base_delay = Duration::from_millis(1);
    config.policy.rate_limits.insert(
        "orders_v0.get_orders".into(),
        RateLimit {
            rate_per_second: 10.0,
            burst: 1,
        },
    );
    let client = Client::with_config(config).unwrap();
    let started = Instant::now();
    let statuses: Vec<u16> = pages(
        &client,
        apis::pagination::mapping("orders_v0.get_orders").unwrap(),
        &json!({"marketplace_ids": ["ATVPDKIKX0DER"]}),
        None,
    )
    .map(|p| p.unwrap().status)
    .collect()
    .await;
    assert_eq!(statuses, [200, 200, 200]);
    let recorded = api.recorded();
    assert_eq!(recorded.len(), 4, "one retry on the first page");
    assert!(
        recorded
            .iter()
            .all(|r| r.headers.contains("x-amz-access-token: managed-token"))
    );
    assert_eq!(lwa.recorded().len(), 1, "one managed token for all pages");
    // 4 acquisitions at 10/s with a burst of 1 need at least 3 refills.
    assert!(
        started.elapsed() >= Duration::from_millis(250),
        "{:?}",
        started.elapsed()
    );
}

#[tokio::test]
async fn timeout_applies_per_page() {
    let server = serve(vec![
        (200, r#"{"payload":{"NextToken":"A"}}"#.into()),
        (200, "{}".into()),
    ])
    .await;
    let client = Client::with_timeout(&server.url, SECRET, Duration::from_millis(500)).unwrap();
    let count = pages(
        &client,
        apis::pagination::mapping("orders_v0.get_orders").unwrap(),
        &json!({"marketplace_ids": ["ATVPDKIKX0DER"]}),
        None,
    )
    .count()
    .await;
    assert_eq!(count, 2);
}

#[test]
fn generated_table_is_complete_and_consistent() {
    let all = apis::pagination::mappings();
    assert_eq!(all.len(), 79);
    let mut keys: Vec<_> = all.iter().map(|p| p.operation.clone()).collect();
    keys.dedup();
    assert_eq!(keys.len(), all.len());
    for mapping in all {
        assert!(mapping.input.starts_with('/') && mapping.output.starts_with('/'));
    }
    let adapters: Vec<_> = apis::pagination::mappings()
        .into_iter()
        .filter(|p| {
            p.continuation
                .operation
                .as_deref()
                .is_some_and(|o| o.ends_with(".continue"))
        })
        .map(|p| p.operation)
        .collect();
    assert_eq!(
        adapters,
        [
            "feeds_2021_06_30.get_feeds",
            "reports_2021_06_30.get_reports"
        ]
    );
    let relations =
        apis::pagination::mapping("aplus_content_2020_11_01.list_content_document_asin_relations")
            .unwrap();
    assert_eq!(relations.continuation.operation, None);
    assert_eq!(
        relations.continuation.keep,
        Some(vec![
            "content_reference_key".to_owned(),
            "marketplace_id".to_owned()
        ])
    );
}
