mod support;

use peddler::{
    Client, ClientConfig, Error, Request,
    apis::catalog_items_2022_04_01::{GetCatalogItemParams, get_catalog_item},
    auth::{AuthError, LwaClient, TokenSource},
};
use std::{
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
    time::{Duration, Instant},
};
use support::{bind, http, replies};
use tokio::io::{AsyncReadExt, AsyncWriteExt};

fn request(method: &str) -> Request {
    Request {
        method: method.into(),
        path: "/test".into(),
        query: vec![],
        body: None,
    }
}
fn retrying(base: String, max_retries: u32) -> ClientConfig {
    let mut config = ClientConfig::new(base, "static");
    config.retry.max_retries = max_retries;
    config
}
#[tokio::test]
async fn retry_safe_get_but_never_patch_and_keep_final_response() {
    let api = replies(vec![
        http(429, "Retry-After: 0\r\n", b"first"),
        http(200, "", b"ok"),
        http(429, "x-repeat: a\r\nx-repeat: b\r\n", b"last"),
    ])
    .await;
    let client = Client::with_config(retrying(api.url.clone(), 2)).unwrap();
    assert_eq!(client.execute(request("GET")).await.unwrap().body, b"ok");
    let final_response = client.execute(request("PATCH")).await.unwrap();
    assert_eq!(final_response.body, b"last");
    assert_eq!(final_response.status, 429);
    assert_eq!(api.requests().len(), 3);
}
#[tokio::test]
async fn backoff_longer_than_the_deadline_returns_the_last_response() {
    let api = replies(vec![http(429, "Retry-After: 1\r\n", b"retain")]).await;
    let mut c = retrying(api.url.clone(), 1);
    c.timeout = Duration::from_millis(50);
    let client = Client::with_config(c).unwrap();
    assert_eq!(
        client.execute(request("GET")).await.unwrap().body,
        b"retain"
    );
    assert_eq!(api.requests().len(), 1);
}
#[tokio::test]
async fn one_deadline_covers_every_attempt_and_the_retry_delay() {
    let (listener, base) = bind().await;
    let api = tokio::spawn(async move {
        let mut buf = [0; 4096];
        let (mut socket, _) = listener.accept().await.unwrap();
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        tokio::time::sleep(Duration::from_millis(200)).await;
        socket
            .write_all(b"HTTP/1.1 503 Test\r\nContent-Length: 0\r\nConnection: close\r\n\r\n")
            .await
            .unwrap();
        // The second attempt is never answered and is cut off by the first one's deadline.
        let (mut socket, _) = listener.accept().await.unwrap();
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        assert_eq!(socket.read(&mut buf).await.unwrap(), 0);
    });
    // The first retry waits 200 milliseconds at most, which leaves time for the attempt.
    let mut c = retrying(base, 3);
    c.timeout = Duration::from_millis(600);
    let client = Client::with_config(c).unwrap();
    let started = Instant::now();
    assert_eq!(
        client.execute(request("GET")).await.unwrap_err(),
        Error::Timeout
    );
    // A deadline per attempt would have allowed 200 + 600 milliseconds.
    assert!(
        started.elapsed() < Duration::from_millis(800),
        "{:?}",
        started.elapsed()
    );
    api.await.unwrap();
}
#[tokio::test]
async fn a_view_sends_its_own_token_and_leaves_the_original_unchanged() {
    let api = replies(vec![http(200, "", b"ok"); 2]).await;
    let client = Client::new(&api.url, "base-token").unwrap();
    let view = client.with_access_token("seller-b").unwrap();
    view.execute(request("GET")).await.unwrap();
    client.execute(request("GET")).await.unwrap();
    let requests = api.requests();
    assert!(requests[0].contains("x-amz-access-token: seller-b"));
    assert!(requests[1].contains("x-amz-access-token: base-token"));
    for invalid in ["", " ", "bad\r\ntoken"] {
        assert_eq!(
            client.with_access_token(invalid).unwrap_err(),
            Error::InvalidRequest
        );
    }
    assert!(!format!("{view:?}").contains("seller-b"));
}
/// A source that hands out token-1, token-2 and so on, and the number of times it was asked.
fn counting_source() -> (TokenSource, Arc<AtomicUsize>) {
    let asked = Arc::new(AtomicUsize::new(0));
    let count = asked.clone();
    let source = TokenSource::new(move || {
        let number = count.fetch_add(1, Ordering::SeqCst) + 1;
        async move { Ok(format!("token-{number}")) }
    });
    (source, asked)
}
#[tokio::test]
async fn a_token_source_is_asked_once_per_attempt_so_a_retry_sends_a_fresh_token() {
    let api = replies(vec![
        http(429, "Retry-After: 0\r\n", b"throttled"),
        http(200, "", b"{}"),
        http(503, "Retry-After: 0\r\n", b"busy"),
        http(200, "", b"{}"),
        http(200, "", b"{}"),
    ])
    .await;
    let (source, asked) = counting_source();
    let mut config = ClientConfig::new(api.url.clone(), source);
    config.retry.max_retries = 1;
    let client = Client::with_config(config).unwrap();
    assert_eq!(asked.load(Ordering::SeqCst), 0, "construction asks nothing");
    assert_eq!(client.execute(request("GET")).await.unwrap().status, 200);
    let catalog = GetCatalogItemParams::new("ASIN".into(), vec!["UK".into()]);
    assert_eq!(
        get_catalog_item(&client, catalog).await.unwrap().raw.status,
        200
    );
    // A view pins a plain token and stops asking the source.
    let pinned = client.with_access_token("pinned").unwrap();
    pinned.execute(request("GET")).await.unwrap();
    let requests = api.requests();
    let tokens: Vec<_> = requests
        .iter()
        .map(|request| header(request, "x-amz-access-token").unwrap())
        .collect();
    assert_eq!(
        tokens,
        ["token-1", "token-2", "token-3", "token-4", "pinned"]
    );
    assert_eq!(asked.load(Ordering::SeqCst), 4);
    assert!(!format!("{client:?} {pinned:?}").contains("token-"));
}
#[tokio::test]
async fn a_failing_token_source_is_the_auth_error_and_sends_nothing() {
    let (listener, base) = bind().await;
    let rejected = AuthError::Rejected {
        status: 400,
        code: Some("invalid_grant".into()),
    };
    for (reply, expected) in [
        (Err(rejected.clone()), Error::Authentication(rejected)),
        (
            Ok(String::new()),
            Error::Authentication(AuthError::InvalidResponse),
        ),
    ] {
        let asked = Arc::new(AtomicUsize::new(0));
        let count = asked.clone();
        let source = TokenSource::new(move || {
            count.fetch_add(1, Ordering::SeqCst);
            let reply = reply.clone();
            async move { reply }
        });
        let mut config = ClientConfig::new(base.clone(), source);
        config.retry.max_retries = 3;
        let client = Client::with_config(config).unwrap();
        assert_eq!(client.execute(request("GET")).await.unwrap_err(), expected);
        // The source itself is never retried.
        assert_eq!(asked.load(Ordering::SeqCst), 1);
    }
    // The deadline of a call covers a source that never answers.
    let stuck = TokenSource::new(std::future::pending::<Result<String, AuthError>>);
    let mut config = ClientConfig::new(base, stuck);
    config.timeout = Duration::from_millis(30);
    let client = Client::with_config(config).unwrap();
    assert_eq!(
        client.execute(request("GET")).await.unwrap_err(),
        Error::Timeout
    );
    assert!(
        tokio::time::timeout(Duration::from_millis(30), listener.accept())
            .await
            .is_err(),
        "no request reaches the server"
    );
}
/// A client whose token comes from the in-process LWA source.
fn managed(base: String, lwa: String) -> ClientConfig {
    let source = LwaClient::with_config("dummy-id", "dummy-secret", &lwa, Duration::from_secs(2))
        .unwrap()
        .source_for_refresh_token("dummy-refresh")
        .unwrap();
    ClientConfig::new(base, source)
}
const FRESH: &str = r#"{"access_token":"fresh-token","token_type":"bearer","expires_in":3600}"#;
#[tokio::test]
async fn lwa_source_shares_one_refresh_across_raw_generated_and_concurrent_clones() {
    let auth = replies(vec![http(200, "", FRESH.as_bytes())]).await;
    let api = replies(vec![http(200, "", b"{}"); 8]).await;
    let client = Client::with_config(managed(api.url.clone(), auth.url.clone())).unwrap();
    let mut tasks = vec![];
    for n in 0..8 {
        let c = client.clone();
        tasks.push(tokio::spawn(async move {
            if n % 2 == 0 {
                c.execute(request("GET")).await.unwrap();
            } else {
                get_catalog_item(
                    &c,
                    GetCatalogItemParams::new("ASIN".into(), vec!["UK".into()]),
                )
                .await
                .unwrap();
            }
        }));
    }
    for t in tasks {
        t.await.unwrap();
    }
    assert_eq!(auth.requests().len(), 1);
    for r in api.requests() {
        assert!(r.contains("x-amz-access-token: fresh-token"));
    }
}
#[tokio::test]
async fn lwa_source_failure_is_the_auth_error_and_the_next_call_recovers() {
    let auth = replies(vec![
        http(
            401,
            "",
            br#"{"error":"invalid_grant","error_description":"dummy-secret"}"#,
        ),
        http(200, "", FRESH.as_bytes()),
    ])
    .await;
    let api = replies(vec![http(200, "", b"ok")]).await;
    let client = Client::with_config(managed(api.url.clone(), auth.url.clone())).unwrap();
    let mut invalid = request("GET");
    invalid.path = "//foreign".into();
    assert_eq!(
        client.execute(invalid).await.unwrap_err(),
        Error::InvalidRequest
    );
    let err = client.execute(request("GET")).await.unwrap_err();
    assert_eq!(
        err,
        Error::Authentication(AuthError::Rejected {
            status: 401,
            code: Some("invalid_grant".into())
        })
    );
    assert!(!format!("{err:?}").contains("dummy-secret"));
    client.execute(request("GET")).await.unwrap();
    assert_eq!(auth.requests().len(), 2, "invalid input asked nothing");
    assert_eq!(api.requests().len(), 1);
}
#[tokio::test]
async fn lwa_source_refreshes_an_expired_token_for_the_retry() {
    let token1 = r#"{"access_token":"first","token_type":"bearer","expires_in":1}"#;
    let token2 = r#"{"access_token":"second","token_type":"bearer","expires_in":3600}"#;
    let auth = replies(vec![
        http(200, "", token1.as_bytes()),
        http(200, "", token2.as_bytes()),
    ])
    .await;
    let api = replies(vec![
        http(429, "Retry-After: 1\r\n", b"retry"),
        http(200, "", b"ok"),
    ])
    .await;
    let mut c = managed(api.url.clone(), auth.url.clone());
    c.retry.max_retries = 1;
    let client = Client::with_config(c).unwrap();
    client.execute(request("GET")).await.unwrap();
    assert_eq!(auth.requests().len(), 2);
    let requests = api.requests();
    assert!(requests[0].contains("x-amz-access-token: first"));
    assert!(requests[1].contains("x-amz-access-token: second"));
}
#[tokio::test]
async fn cancelled_lwa_source_refresh_closes_socket_and_recovers() {
    let (listener, lwa) = bind().await;
    let (started, waiting) = tokio::sync::oneshot::channel();
    let auth = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        let mut buf = [0; 4096];
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        started.send(()).unwrap();
        assert_eq!(
            socket.read(&mut buf).await.unwrap(),
            0,
            "cancellation must close the socket"
        );
        let (mut socket, _) = listener.accept().await.unwrap();
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        socket
            .write_all(
                format!(
                    "HTTP/1.1 200 OK\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{FRESH}",
                    FRESH.len()
                )
                .as_bytes(),
            )
            .await
            .unwrap();
    });
    let api = replies(vec![http(200, "", b"ok")]).await;
    let client = Client::with_config(managed(api.url.clone(), lwa)).unwrap();
    let clone = client.clone();
    let task = tokio::spawn(async move { clone.execute(request("GET")).await });
    waiting.await.unwrap();
    task.abort();
    assert!(task.await.unwrap_err().is_cancelled());
    tokio::time::timeout(Duration::from_secs(1), client.execute(request("GET")))
        .await
        .unwrap()
        .unwrap();
    auth.await.unwrap();
    assert_eq!(api.requests().len(), 1);
}
#[tokio::test]
async fn overall_deadline_cancels_the_lwa_source_socket() {
    let (listener, lwa) = bind().await;
    let auth = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        let mut buf = [0; 4096];
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        assert_eq!(socket.read(&mut buf).await.unwrap(), 0);
    });
    let mut c = managed("http://127.0.0.1:1".into(), lwa);
    c.timeout = Duration::from_millis(30);
    let client = Client::with_config(c).unwrap();
    assert_eq!(
        client.execute(request("GET")).await.unwrap_err(),
        Error::Timeout
    );
    auth.await.unwrap();
}
#[tokio::test]
async fn cancelled_request_closes_socket_and_client_recovers() {
    let (listener, base) = bind().await;
    let (started, waiting) = tokio::sync::oneshot::channel();
    let api = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        let mut buf = [0; 4096];
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        started.send(()).unwrap();
        assert_eq!(
            socket.read(&mut buf).await.unwrap(),
            0,
            "cancellation must close the socket"
        );
        let (mut socket, _) = listener.accept().await.unwrap();
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        socket
            .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 2\r\nConnection: close\r\n\r\nok")
            .await
            .unwrap();
    });
    let client = Client::new(&base, "static").unwrap();
    let clone = client.clone();
    let task = tokio::spawn(async move { clone.execute(request("GET")).await });
    waiting.await.unwrap();
    task.abort();
    assert!(task.await.unwrap_err().is_cancelled());
    tokio::time::timeout(Duration::from_secs(1), client.execute(request("GET")))
        .await
        .unwrap()
        .unwrap();
    api.await.unwrap();
}
#[tokio::test]
async fn overall_deadline_closes_the_socket() {
    let (listener, base) = bind().await;
    let api = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        let mut buf = [0; 4096];
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        assert_eq!(socket.read(&mut buf).await.unwrap(), 0);
    });
    let client = Client::with_timeout(&base, "static", Duration::from_millis(30)).unwrap();
    assert_eq!(
        client.execute(request("GET")).await.unwrap_err(),
        Error::Timeout
    );
    api.await.unwrap();
}

#[tokio::test]
async fn generated_get_uses_retry_policy_and_retains_final_error() {
    let api = replies(vec![
        http(429, "Retry-After: 0\r\n", b"first"),
        http(200, "", b"{}"),
        http(503, "Retry-After: 2\r\n", b"unparsed"),
    ])
    .await;
    let mut c = retrying(api.url.clone(), 1);
    c.timeout = Duration::from_secs(1);
    let client = Client::with_config(c).unwrap();
    assert_eq!(
        get_catalog_item(
            &client,
            GetCatalogItemParams::new("ASIN".into(), vec!["UK".into()])
        )
        .await
        .unwrap()
        .raw
        .status,
        200
    );
    let last = get_catalog_item(
        &client,
        GetCatalogItemParams::new("ASIN".into(), vec!["UK".into()]),
    )
    .await
    .unwrap()
    .into_raw();
    assert_eq!(last.status, 503);
    assert_eq!(last.body, b"unparsed");
    assert_eq!(api.requests().len(), 3);
}

fn header<'a>(request: &'a str, name: &str) -> Option<&'a str> {
    request
        .lines()
        .find_map(|line| line.strip_prefix(name)?.strip_prefix(": "))
}
#[tokio::test]
async fn user_agent_is_the_crates_own_unless_the_caller_identifies_itself() {
    let api = replies(vec![http(200, "", b"{}"); 3]).await;
    let own = Client::new(&api.url, "static").unwrap();
    own.execute(request("GET")).await.unwrap();
    let mut c = ClientConfig::new(api.url.clone(), "static");
    c.user_agent = Some("Peddler/6.0.0 (Language=Ruby; host)".into());
    let wrapped = Client::with_config(c).unwrap();
    wrapped.execute(request("GET")).await.unwrap();
    get_catalog_item(
        &wrapped.with_access_token("other").unwrap(),
        GetCatalogItemParams::new("ASIN".into(), vec!["UK".into()]),
    )
    .await
    .unwrap();
    let requests = api.requests();
    assert_eq!(
        header(&requests[0], "user-agent"),
        Some(concat!(
            "Peddler/",
            env!("CARGO_PKG_VERSION"),
            " (Language=Rust)"
        ))
    );
    for request in &requests[1..] {
        assert_eq!(
            header(request, "user-agent"),
            Some("Peddler/6.0.0 (Language=Ruby; host)")
        );
    }
    let mut invalid = ClientConfig::new(api.url.clone(), "static");
    invalid.user_agent = Some("bad\r\nvalue".into());
    assert_eq!(
        Client::with_config(invalid).unwrap_err(),
        Error::InvalidRequest
    );
}
