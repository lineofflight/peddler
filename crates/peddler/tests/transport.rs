use base64::{Engine, engine::general_purpose::STANDARD};
use peddler::{Client, Error, Request};
use serde::Deserialize;
use std::time::Duration;
use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::{TcpListener, TcpStream},
    task::JoinHandle,
};

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

async fn read_request(stream: &mut TcpStream) -> Vec<u8> {
    let mut bytes = Vec::new();
    loop {
        let mut chunk = [0; 4096];
        let count = stream.read(&mut chunk).await.unwrap();
        assert!(count > 0, "request ended before its body");
        bytes.extend_from_slice(&chunk[..count]);
        if let Some(end) = bytes.windows(4).position(|part| part == b"\r\n\r\n") {
            let headers = String::from_utf8_lossy(&bytes[..end]).to_ascii_lowercase();
            let length = headers
                .lines()
                .find_map(|line| line.strip_prefix("content-length: ")?.parse::<usize>().ok())
                .unwrap_or(0);
            if bytes.len() >= end + 4 + length {
                return bytes;
            }
        }
    }
}

fn wire_response(status: u16, headers: &[(String, String)], body: &[u8], close: bool) -> Vec<u8> {
    let mut response = format!(
        "HTTP/1.1 {status} Test\r\nContent-Length: {}\r\n",
        body.len()
    );
    if close {
        response.push_str("Connection: close\r\n");
    }
    for (name, value) in headers {
        response.push_str(&format!("{name}: {value}\r\n"));
    }
    response.push_str("\r\n");
    [response.as_bytes(), body].concat()
}

async fn server(responses: Vec<Vec<u8>>) -> (String, JoinHandle<Vec<Vec<u8>>>) {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let mut requests = Vec::new();
        for response in responses {
            let (mut stream, _) = listener.accept().await.unwrap();
            requests.push(read_request(&mut stream).await);
            stream.write_all(&response).await.unwrap();
        }
        requests
    });
    (origin, task)
}

fn get(path: &str) -> Request {
    Request {
        method: "GET".into(),
        path: path.into(),
        query: vec![],
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
        let (origin, task) = server(vec![wire_response(
            fixture.response.status,
            &fixture.response.headers,
            &expected_body,
            true,
        )])
        .await;
        let client = Client::new(&origin, TOKEN).unwrap();
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
                body,
            })
            .await
            .unwrap();
        assert_eq!(response.status, fixture.response.status);
        assert_eq!(response.body, expected_body);
        for header in fixture.response.headers {
            assert!(response.headers.contains(&header));
        }
        let requests = task.await.unwrap();
        let request = String::from_utf8_lossy(&requests[0]);
        let first_line = request.lines().next().unwrap();
        let target = first_line.split(' ').nth(1).unwrap();
        assert!(first_line.starts_with(&format!("{method} {path}")));
        let url = reqwest::Url::parse(&format!("{origin}{target}")).unwrap();
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
        let end = requests[0]
            .windows(4)
            .position(|part| part == b"\r\n\r\n")
            .unwrap()
            + 4;
        assert_eq!(&requests[0][end..], expected_request_body);
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
    let (origin, task) = server(vec![wire_response(200, &[], b"", true)]).await;
    let client = Client::new(&origin, TOKEN).unwrap();
    let mut request = get("/items/a%2Fb%20c%3F%23");
    request.query = vec![
        ("includedData".into(), "images,summaries".into()),
        ("tag".into(), "a b&c".into()),
        ("tag".into(), "second".into()),
    ];
    client.execute(request).await.unwrap();
    let requests = task.await.unwrap();
    assert!(String::from_utf8_lossy(&requests[0]).starts_with("GET /items/a%2Fb%20c%3F%23?includedData=images%2Csummaries&tag=a+b%26c&tag=second HTTP/1.1\r\n"));
}

#[tokio::test]
async fn preserves_binary_body_and_repeated_headers_without_decompression() {
    let body = [0x1f, 0x8b, 0xff, 0, 0x80];
    let headers = vec![
        ("x-repeat".into(), "first".into()),
        ("x-repeat".into(), "second".into()),
        ("content-encoding".into(), "gzip".into()),
    ];
    let (origin, task) = server(vec![wire_response(200, &headers, &body, true)]).await;
    let response = Client::new(&origin, TOKEN)
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
    let requests = task.await.unwrap();
    assert!(
        !String::from_utf8_lossy(&requests[0])
            .to_ascii_lowercase()
            .contains("accept-encoding:")
    );
}

#[tokio::test]
async fn returns_redirect_response_without_contacting_target() {
    let target = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let location = format!("http://{}/secret", target.local_addr().unwrap());
    let (origin, task) = server(vec![wire_response(
        302,
        &[("location".into(), location)],
        b"redirect",
        true,
    )])
    .await;
    let response = Client::new(&origin, TOKEN)
        .unwrap()
        .execute(get("/"))
        .await
        .unwrap();
    assert_eq!(response.status, 302);
    assert_eq!(response.body, b"redirect");
    task.await.unwrap();
    assert!(
        tokio::time::timeout(Duration::from_millis(50), target.accept())
            .await
            .is_err()
    );
}

#[tokio::test]
async fn enforces_timeout_while_waiting_for_response() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        read_request(&mut stream).await;
        tokio::time::sleep(Duration::from_secs(5)).await;
    });
    let client = Client::with_timeout(&origin, TOKEN, Duration::from_millis(30)).unwrap();
    assert_eq!(client.execute(get("/")).await.unwrap_err(), Error::Timeout);
    task.abort();
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
    assert_eq!(
        Client::with_timeout("https://example.com", TOKEN, Duration::ZERO).unwrap_err(),
        Error::InvalidRequest
    );
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
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
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
async fn concurrent_clones_share_client_and_complete_requests() {
    let responses = (0..8)
        .map(|_| wire_response(200, &[], b"ok", true))
        .collect();
    let (origin, task) = server(responses).await;
    let client = Client::new(&origin, TOKEN).unwrap();
    let mut tasks = Vec::new();
    for index in 0..8 {
        let clone = client.clone();
        tasks.push(tokio::spawn(async move {
            clone
                .execute(get(&format!("/items/{index}")))
                .await
                .unwrap()
        }));
    }
    for task in tasks {
        assert_eq!(task.await.unwrap().body, b"ok");
    }
    assert_eq!(task.await.unwrap().len(), 8);
}

#[tokio::test]
async fn sequential_clones_reuse_the_same_connection() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        for _ in 0..2 {
            read_request(&mut stream).await;
            stream
                .write_all(&wire_response(200, &[], b"ok", false))
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
