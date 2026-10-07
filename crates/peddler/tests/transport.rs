mod support;

use base64::{Engine, engine::general_purpose::STANDARD};
use peddler::{Client, Error, Request};
use serde::Deserialize;
use std::time::Duration;
use support::{bind, http, read_request, replies};
use tokio::io::AsyncWriteExt;

const TOKEN: &str = "synthetic-secret-token";

#[derive(Deserialize)]
struct Fixture {
    request: FixtureRequest,
    response: FixtureResponse,
}
#[derive(Deserialize)]
struct FixtureRequest {
    method: String,
    path: String,
    query: Vec<(String, String)>,
    body_base64: Option<String>,
}
#[derive(Deserialize)]
struct FixtureResponse {
    status: u16,
    headers: Vec<(String, String)>,
    body_base64: String,
}

fn get(path: &str) -> Request {
    Request {
        method: "GET".into(),
        path: path.into(),
        query: vec![],
        headers: vec![],
        body: None,
    }
}

#[tokio::test]
async fn replays_selected_get_patch_and_http_error_contracts() {
    for content in [
        include_str!("../../../test/fixtures/native/catalog_get.json"),
        include_str!("../../../test/fixtures/native/listings_patch.json"),
        include_str!("../../../test/fixtures/native/not_found.json"),
    ] {
        let fixture: Fixture = serde_json::from_str(content).unwrap();
        let expected_body = STANDARD.decode(&fixture.response.body_base64).unwrap();
        let headers: String = fixture
            .response
            .headers
            .iter()
            .map(|(name, value)| format!("{name}: {value}\r\n"))
            .collect();
        let server = replies(vec![http(
            fixture.response.status,
            &headers,
            &expected_body,
        )])
        .await;
        let client = Client::new(&server.url, TOKEN).unwrap();
        let body = fixture
            .request
            .body_base64
            .map(|value| STANDARD.decode(value).unwrap());
        let expected_request_body = body.clone().unwrap_or_default();
        let method = fixture.request.method;
        let path = fixture.request.path;
        let query = fixture.request.query;
        let response = client
            .execute(Request {
                method: method.clone(),
                path: path.clone(),
                query: query.clone(),
                headers: vec![],
                body,
            })
            .await
            .unwrap();
        assert_eq!(response.status, fixture.response.status);
        assert_eq!(response.body, expected_body);
        for header in fixture.response.headers {
            assert!(response.headers.contains(&header));
        }
        let request = &server.requests()[0];
        let first_line = request.lines().next().unwrap();
        let target = first_line.split(' ').nth(1).unwrap();
        assert!(first_line.starts_with(&format!("{method} {path}")));
        let url = reqwest::Url::parse(&format!("{}{target}", server.url)).unwrap();
        assert_eq!(url.path(), path);
        assert_eq!(
            url.query_pairs()
                .map(|(key, value)| (key.into_owned(), value.into_owned()))
                .collect::<Vec<_>>(),
            query
        );
        assert!(
            request
                .to_ascii_lowercase()
                .contains(&format!("x-amz-access-token: {TOKEN}"))
        );
        assert!(
            request
                .to_ascii_lowercase()
                .contains("user-agent: peddler/")
        );
        assert_eq!(
            request.split_once("\r\n\r\n").unwrap().1.as_bytes(),
            expected_request_body
        );
        if method == "PATCH" {
            assert!(
                request
                    .to_ascii_lowercase()
                    .contains("content-type: application/json")
            );
        }
    }
}

#[tokio::test]
async fn preserves_escaped_paths_and_ordered_csv_query_values() {
    let server = replies(vec![http(200, "", b"")]).await;
    let client = Client::new(&server.url, TOKEN).unwrap();
    let mut request = get("/items/a%2Fb%20c%3F%23");
    request.query = vec![
        ("includedData".into(), "images,summaries".into()),
        ("tag".into(), "a b&c".into()),
        ("tag".into(), "second".into()),
    ];
    client.execute(request).await.unwrap();
    assert!(server.requests()[0].starts_with("GET /items/a%2Fb%20c%3F%23?includedData=images%2Csummaries&tag=a+b%26c&tag=second HTTP/1.1\r\n"));
}

#[tokio::test]
async fn sends_request_headers_and_refuses_reserved_and_invalid_ones() {
    let server = replies(vec![http(200, "", b"")]).await;
    let client = Client::new(&server.url, TOKEN).unwrap();
    let mut request = get("/");
    request.headers = vec![
        ("X-Amzn-Idempotency-Token".into(), "one".into()),
        ("Accept-Language".into(), "en-GB".into()),
    ];
    client.execute(request).await.unwrap();
    let sent = server.requests()[0].to_ascii_lowercase();
    assert!(sent.contains("\r\nx-amzn-idempotency-token: one\r\n"));
    assert!(sent.contains("\r\naccept-language: en-gb\r\n"));
    for (name, value) in [
        ("Host", "forged.example"),
        ("content-length", "0"),
        ("Transfer-Encoding", "chunked"),
        ("connection", "close"),
        ("Content-Type", "text/plain"),
        ("ACCEPT", "text/plain"),
        ("User-Agent", "forged"),
        ("x-amz-access-token", "forged"),
        ("X-Amz-Date", "20260101T000000Z"),
        ("x-amz-anything", "forged"),
        ("bad name", "value"),
        ("x-test", "secret\r\ninjected: yes"),
    ] {
        let mut request = get("/");
        request.headers = vec![(name.into(), value.into())];
        assert_eq!(
            client.execute(request).await.unwrap_err(),
            Error::InvalidRequest,
            "{name}"
        );
    }
    assert_eq!(server.requests().len(), 1);
}

#[tokio::test]
async fn preserves_binary_body_and_repeated_headers_without_decompression() {
    let body = [0x1f, 0x8b, 0xff, 0, 0x80];
    let headers = [
        ("x-repeat".to_owned(), "first".to_owned()),
        ("x-repeat".into(), "second".into()),
        ("content-encoding".into(), "gzip".into()),
    ];
    let server = replies(vec![http(
        200,
        "x-repeat: first\r\nx-repeat: second\r\ncontent-encoding: gzip\r\n",
        &body,
    )])
    .await;
    let response = Client::new(&server.url, TOKEN)
        .unwrap()
        .execute(get("/binary"))
        .await
        .unwrap();
    assert_eq!(response.body, body);
    assert_eq!(
        response
            .headers
            .iter()
            .filter(|(name, _)| name == "x-repeat")
            .cloned()
            .collect::<Vec<_>>(),
        headers[..2]
    );
    assert!(response.headers.contains(&headers[2]));
    assert!(
        !server.requests()[0]
            .to_ascii_lowercase()
            .contains("accept-encoding:")
    );
}

#[tokio::test]
async fn returns_redirect_response_without_contacting_target() {
    let (target, target_url) = bind().await;
    let location = format!("{target_url}/secret");
    let server = replies(vec![http(
        302,
        &format!("location: {location}\r\n"),
        b"redirect",
    )])
    .await;
    let response = Client::new(&server.url, TOKEN)
        .unwrap()
        .execute(get("/"))
        .await
        .unwrap();
    assert_eq!(response.status, 302);
    assert_eq!(response.body, b"redirect");
    assert!(
        tokio::time::timeout(Duration::from_millis(50), target.accept())
            .await
            .is_err()
    );
}

#[test]
fn rejects_invalid_origins_tokens_and_zero_timeout() {
    for origin in [
        "ftp://example.com",
        "example.com",
        "https://user:password@example.com",
        "https://@example.com",
        "https://example.com/path",
        "https://example.com?query",
        "https://example.com#fragment",
        "https:\\example.com",
        "https://example.com/../",
        "https://example.com\\",
        " https://example.com",
        // The access token never travels over plain HTTP beyond loopback.
        "http://example.com",
    ] {
        assert_eq!(
            Client::new(origin, TOKEN).unwrap_err(),
            Error::InvalidRequest,
            "{origin}"
        );
    }
    for token in ["", "secret\r\ninjected: yes", "secret\0"] {
        assert_eq!(
            Client::new("https://example.com", token).unwrap_err(),
            Error::InvalidRequest
        );
    }
    // Zero, and one too long for a deadline to be set by: every call would fail.
    for timeout in [Duration::ZERO, Duration::MAX] {
        assert_eq!(
            Client::with_timeout("https://example.com", TOKEN, timeout).unwrap_err(),
            Error::InvalidRequest
        );
        let mut config = peddler::ClientConfig::new("https://example.com", TOKEN);
        config.timeout = timeout;
        assert_eq!(
            Client::with_config(config).unwrap_err(),
            Error::InvalidRequest
        );
    }
}

#[tokio::test]
async fn rejects_paths_that_can_change_origin_or_contain_query_or_fragment() {
    let client = Client::new("http://127.0.0.1:1", TOKEN).unwrap();
    for path in [
        "",
        "relative",
        "https://evil.example/",
        "//evil.example/",
        "/\\evil.example/",
        "/a?query",
        "/a#fragment",
        "/a\r\n",
        "/a b",
        "/%xx",
        "/a\\b",
    ] {
        assert_eq!(
            client.execute(get(path)).await.unwrap_err(),
            Error::InvalidRequest,
            "{path:?}"
        );
    }
    let mut request = get("/");
    request.method = "GET\r\n".into();
    assert_eq!(
        client.execute(request).await.unwrap_err(),
        Error::InvalidRequest
    );
}

#[tokio::test]
async fn transport_failure_and_debug_output_do_not_leak_token_or_url() {
    let (listener, origin) = bind().await;
    drop(listener);
    let client = Client::new(&origin, TOKEN).unwrap();
    let error = client.execute(get("/private-path")).await.unwrap_err();
    assert_eq!(error, Error::Transport);
    for output in [
        format!("{client:?}"),
        format!("{error:?}"),
        error.to_string(),
    ] {
        assert!(!output.contains(TOKEN));
        assert!(!output.contains(&origin));
        assert!(!output.contains("private-path"));
    }
}

#[tokio::test]
async fn sequential_clones_reuse_the_same_connection() {
    let (listener, origin) = bind().await;
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        for _ in 0..2 {
            read_request(&mut stream).await;
            stream
                .write_all(b"HTTP/1.1 200 Test\r\nContent-Length: 2\r\n\r\nok")
                .await
                .unwrap();
        }
    });
    let client = Client::with_timeout(&origin, TOKEN, Duration::from_millis(500)).unwrap();
    assert_eq!(client.execute(get("/first")).await.unwrap().body, b"ok");
    assert_eq!(
        client.clone().execute(get("/second")).await.unwrap().body,
        b"ok"
    );
    task.await.unwrap();
}
