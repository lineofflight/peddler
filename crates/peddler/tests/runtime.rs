use peddler::{
    Client, ClientConfig, Error, Request,
    apis::{
        catalog_items_2022_04_01::{GetCatalogItemParams, get_catalog_item},
        tokens_2021_03_01::{CreateRestrictedDataTokenParams, create_restricted_data_token},
    },
    auth::{AuthError, LwaClient, TokenSource},
};
use std::{
    sync::{
        Arc,
        atomic::{AtomicUsize, Ordering},
    },
    time::{Duration, Instant},
};
use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::TcpListener,
};

type Reply<'a> = (u16, Vec<(&'a str, &'a str)>, &'a str);
async fn server(replies: Vec<Reply<'_>>) -> (String, tokio::task::JoinHandle<Vec<String>>) {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let base = format!("http://{}", listener.local_addr().unwrap());
    let replies: Vec<_> = replies
        .into_iter()
        .map(|(s, h, b)| {
            (
                s,
                h.into_iter()
                    .map(|(k, v)| (k.to_owned(), v.to_owned()))
                    .collect::<Vec<_>>(),
                b.to_owned(),
            )
        })
        .collect();
    let task = tokio::spawn(async move {
        let mut requests = vec![];
        for (status, headers, body) in replies {
            let (mut socket, _) = listener.accept().await.unwrap();
            let mut bytes = vec![];
            loop {
                let mut buf = [0; 4096];
                let count = socket.read(&mut buf).await.unwrap();
                assert!(count > 0);
                bytes.extend_from_slice(&buf[..count]);
                if let Some(end) = bytes.windows(4).position(|w| w == b"\r\n\r\n") {
                    let h = String::from_utf8_lossy(&bytes[..end]).to_ascii_lowercase();
                    let len = h
                        .lines()
                        .find_map(|l| l.strip_prefix("content-length: ")?.parse::<usize>().ok())
                        .unwrap_or(0);
                    if bytes.len() >= end + 4 + len {
                        break;
                    }
                }
            }
            requests.push(String::from_utf8(bytes).unwrap());
            let mut reply = format!(
                "HTTP/1.1 {status} Test\r\nContent-Length: {}\r\nConnection: close\r\n",
                body.len()
            );
            for (k, v) in headers {
                reply.push_str(&format!("{k}: {v}\r\n"));
            }
            reply.push_str("\r\n");
            reply.push_str(&body);
            socket.write_all(reply.as_bytes()).await.unwrap();
        }
        requests
    });
    (base, task)
}
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
async fn raw_generated_and_concurrent_clones_send_the_supplied_token() {
    let (base, api) = server(vec![(200, vec![], "{}"); 8]).await;
    let client = Client::new(&base, "supplied-token").unwrap();
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
    for r in api.await.unwrap() {
        assert!(r.contains("x-amz-access-token: supplied-token"));
    }
}
#[tokio::test]
async fn retry_safe_get_but_never_patch_and_keep_final_response() {
    let (base, api) = server(vec![
        (429, vec![("Retry-After", "0")], "first"),
        (200, vec![], "ok"),
        (429, vec![("x-repeat", "a"), ("x-repeat", "b")], "last"),
    ])
    .await;
    let client = Client::with_config(retrying(base, 2)).unwrap();
    assert_eq!(client.execute(request("GET")).await.unwrap().body, b"ok");
    let final_response = client.execute(request("PATCH")).await.unwrap();
    assert_eq!(final_response.body, b"last");
    assert_eq!(final_response.status, 429);
    assert_eq!(api.await.unwrap().len(), 3);
}
#[tokio::test]
async fn backoff_longer_than_the_deadline_returns_the_last_response() {
    let (base, api) = server(vec![(429, vec![("Retry-After", "1")], "retain")]).await;
    let mut c = retrying(base, 1);
    c.timeout = Duration::from_millis(50);
    let client = Client::with_config(c).unwrap();
    assert_eq!(
        client.execute(request("GET")).await.unwrap().body,
        b"retain"
    );
    assert_eq!(api.await.unwrap().len(), 1);
}
#[tokio::test]
async fn one_deadline_covers_every_attempt_and_the_retry_delay() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let base = format!("http://{}", listener.local_addr().unwrap());
    let api = tokio::spawn(async move {
        let mut buf = [0; 4096];
        let (mut socket, _) = listener.accept().await.unwrap();
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        tokio::time::sleep(Duration::from_millis(300)).await;
        socket
            .write_all(b"HTTP/1.1 503 Test\r\nContent-Length: 0\r\nConnection: close\r\n\r\n")
            .await
            .unwrap();
        // The second attempt is never answered and is cut off by the first one's deadline.
        let (mut socket, _) = listener.accept().await.unwrap();
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        assert_eq!(socket.read(&mut buf).await.unwrap(), 0);
    });
    let mut c = retrying(base, 3);
    c.timeout = Duration::from_millis(500);
    c.retry.base_delay = Duration::from_millis(1);
    let client = Client::with_config(c).unwrap();
    let started = Instant::now();
    assert_eq!(
        client.execute(request("GET")).await.unwrap_err(),
        Error::Timeout
    );
    // A deadline per attempt would have allowed 300 + 500 milliseconds.
    assert!(
        started.elapsed() < Duration::from_millis(700),
        "{:?}",
        started.elapsed()
    );
    api.await.unwrap();
}
#[tokio::test]
async fn views_send_their_own_token_and_a_restricted_data_token_is_an_ordinary_call() {
    let (base, api) = server(vec![
        (
            200,
            vec![],
            r#"{"restrictedDataToken":"rdt-one","expiresIn":3600}"#,
        ),
        (200, vec![], "ok"),
        (200, vec![], "ok"),
        (200, vec![], "ok"),
    ])
    .await;
    let client = Client::new(&base, "base-token").unwrap();
    let scope = serde_json::json!({"restrictedResources":[{"method":"GET","path":"/test"}]});
    let token = create_restricted_data_token(&client, CreateRestrictedDataTokenParams::new(scope))
        .await
        .unwrap()
        .json()
        .unwrap()
        .restricted_data_token
        .unwrap();
    let restricted = client.with_access_token(&token).unwrap();
    restricted.execute(request("GET")).await.unwrap();
    let seller_b = client.with_access_token("seller-b").unwrap();
    seller_b.execute(request("GET")).await.unwrap();
    // The original client is unchanged, and nothing was cached or fetched for a view.
    client.execute(request("GET")).await.unwrap();
    let requests = api.await.unwrap();
    assert!(requests[0].starts_with("POST /tokens/2021-03-01/restrictedDataToken "));
    assert!(requests[0].contains("x-amz-access-token: base-token"));
    assert!(requests[1].contains("x-amz-access-token: rdt-one"));
    assert!(requests[2].contains("x-amz-access-token: seller-b"));
    assert!(requests[3].contains("x-amz-access-token: base-token"));
    for invalid in ["", " ", "bad\r\ntoken"] {
        assert_eq!(
            client.with_access_token(invalid).unwrap_err(),
            Error::InvalidRequest
        );
    }
    assert!(!format!("{restricted:?} {seller_b:?}").contains("rdt-one"));
    assert!(!format!("{restricted:?} {seller_b:?}").contains("seller-b"));
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
    let (base, api) = server(vec![
        (429, vec![("Retry-After", "0")], "throttled"),
        (200, vec![], "{}"),
        (503, vec![("Retry-After", "0")], "busy"),
        (200, vec![], "{}"),
        (200, vec![], "{}"),
    ])
    .await;
    let (source, asked) = counting_source();
    let mut config = ClientConfig::new(base, source);
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
    let requests = api.await.unwrap();
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
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let base = format!("http://{}", listener.local_addr().unwrap());
    let rejected = AuthError::Rejected {
        status: 400,
        code: Some("invalid_grant".into()),
    };
    type Reply = Result<String, AuthError>;
    let replies: [(Reply, Error); 4] = [
        (Err(rejected.clone()), Error::Authentication(rejected)),
        (
            Err(AuthError::Transport),
            Error::Authentication(AuthError::Transport),
        ),
        (
            Ok(String::new()),
            Error::Authentication(AuthError::InvalidResponse),
        ),
        (
            Ok("source-secret\r\nx: y".into()),
            Error::Authentication(AuthError::InvalidResponse),
        ),
    ];
    for (reply, expected) in replies {
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
        let error = client.execute(request("GET")).await.unwrap_err();
        assert_eq!(error, expected);
        assert!(!format!("{error} {error:?}").contains("source-secret"));
        let catalog = GetCatalogItemParams::new("ASIN".into(), vec!["UK".into()]);
        assert_eq!(
            get_catalog_item(&client, catalog).await.unwrap_err(),
            expected
        );
        // Asked once per call: the source itself is never retried.
        assert_eq!(asked.load(Ordering::SeqCst), 2);
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
    let (lwa, auth) = server(vec![(200, vec![], FRESH)]).await;
    let (base, api) = server(vec![(200, vec![], "{}"); 8]).await;
    let client = Client::with_config(managed(base, lwa)).unwrap();
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
    assert_eq!(auth.await.unwrap().len(), 1);
    for r in api.await.unwrap() {
        assert!(r.contains("x-amz-access-token: fresh-token"));
    }
}
#[tokio::test]
async fn lwa_source_failure_is_the_auth_error_and_the_next_call_recovers() {
    let (lwa, auth) = server(vec![
        (
            401,
            vec![],
            r#"{"error":"invalid_grant","error_description":"dummy-secret"}"#,
        ),
        (200, vec![], FRESH),
    ])
    .await;
    let (base, api) = server(vec![(200, vec![], "ok")]).await;
    let client = Client::with_config(managed(base, lwa)).unwrap();
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
    assert_eq!(auth.await.unwrap().len(), 2, "invalid input asked nothing");
    api.await.unwrap();
}
#[tokio::test]
async fn lwa_source_refreshes_an_expired_token_for_the_retry() {
    let token1 = r#"{"access_token":"first","token_type":"bearer","expires_in":1}"#;
    let token2 = r#"{"access_token":"second","token_type":"bearer","expires_in":3600}"#;
    let (lwa, auth) = server(vec![(200, vec![], token1), (200, vec![], token2)]).await;
    let (base, api) = server(vec![
        (429, vec![("Retry-After", "1")], "retry"),
        (200, vec![], "ok"),
    ])
    .await;
    let mut c = managed(base, lwa);
    c.retry.max_retries = 1;
    let client = Client::with_config(c).unwrap();
    client.execute(request("GET")).await.unwrap();
    assert_eq!(auth.await.unwrap().len(), 2);
    let requests = api.await.unwrap();
    assert!(requests[0].contains("x-amz-access-token: first"));
    assert!(requests[1].contains("x-amz-access-token: second"));
}
#[tokio::test]
async fn cancelled_lwa_source_refresh_closes_socket_and_recovers() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let lwa = format!("http://{}", listener.local_addr().unwrap());
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
    let (base, api) = server(vec![(200, vec![], "ok")]).await;
    let client = Client::with_config(managed(base, lwa)).unwrap();
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
    api.await.unwrap();
}
#[tokio::test]
async fn overall_deadline_cancels_the_lwa_source_socket() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let lwa = format!("http://{}", listener.local_addr().unwrap());
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
async fn invalid_input_performs_no_http() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let base = format!("http://{}", listener.local_addr().unwrap());
    let client = Client::new(&base, "static").unwrap();
    let mut invalid = request("GET");
    invalid.path = "//foreign".into();
    assert_eq!(
        client.execute(invalid).await.unwrap_err(),
        Error::InvalidRequest
    );
    assert_eq!(
        get_catalog_item(
            &client,
            GetCatalogItemParams::new("".into(), vec!["UK".into()])
        )
        .await
        .unwrap_err(),
        Error::InvalidRequest
    );
    assert!(
        tokio::time::timeout(Duration::from_millis(30), listener.accept())
            .await
            .is_err()
    );
}
#[tokio::test]
async fn cancelled_request_closes_socket_and_client_recovers() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let base = format!("http://{}", listener.local_addr().unwrap());
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
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let base = format!("http://{}", listener.local_addr().unwrap());
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
    let (base, api) = server(vec![
        (429, vec![("Retry-After", "0")], "first"),
        (200, vec![], "{}"),
        (503, vec![("Retry-After", "2")], "unparsed"),
    ])
    .await;
    let mut c = retrying(base, 1);
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
    assert_eq!(api.await.unwrap().len(), 3);
}

#[tokio::test]
async fn full_generated_sellers_operation_uses_the_safe_retry_runner() {
    use peddler::apis::sellers_v1::{
        GetMarketplaceParticipationsParams, get_marketplace_participations,
    };
    let (base, api) = server(vec![
        (503, vec![("Retry-After", "0")], "temporary"),
        (200, vec![], "{\"payload\":[]}"),
    ])
    .await;
    let client = Client::with_config(retrying(base, 1)).unwrap();
    let response =
        get_marketplace_participations(&client, GetMarketplaceParticipationsParams::new())
            .await
            .unwrap();
    assert_eq!(response.raw.status, 200);
    assert!(response.json().unwrap().payload.unwrap().is_empty());
    let requests = api.await.unwrap();
    assert_eq!(requests.len(), 2);
    for request in requests {
        assert!(request.starts_with("GET /sellers/v1/marketplaceParticipations "));
        assert!(request.contains("x-amz-access-token: static"));
    }
}

fn header<'a>(request: &'a str, name: &str) -> Option<&'a str> {
    request
        .lines()
        .find_map(|line| line.strip_prefix(name)?.strip_prefix(": "))
}
// The form v5 sent and Amazon's connection guide shows: 20250911T221313Z.
fn is_amz_date(value: &str) -> bool {
    value.len() == 16
        && value.bytes().enumerate().all(|(index, byte)| match index {
            8 => byte == b'T',
            15 => byte == b'Z',
            _ => byte.is_ascii_digit(),
        })
}

#[tokio::test]
async fn every_api_attempt_carries_its_own_x_amz_date() {
    let (base, api) = server(vec![
        (429, vec![("Retry-After", "1")], "first"),
        (200, vec![], "{}"),
        (200, vec![], "{}"),
    ])
    .await;
    let client = Client::with_config(retrying(base, 1)).unwrap();
    assert_eq!(client.execute(request("GET")).await.unwrap().status, 200);
    get_catalog_item(
        &client,
        GetCatalogItemParams::new("ASIN".into(), vec!["UK".into()]),
    )
    .await
    .unwrap();
    let requests = api.await.unwrap();
    let dates: Vec<_> = requests
        .iter()
        .map(|request| header(request, "x-amz-date").expect("x-amz-date"))
        .collect();
    assert_eq!(dates.len(), 3);
    assert!(dates.iter().all(|date| is_amz_date(date)), "{dates:?}");
    // The retry waited a second, so a header set once per request would repeat.
    assert_ne!(dates[0], dates[1]);
}

#[tokio::test]
async fn user_agent_is_the_crates_own_unless_the_caller_identifies_itself() {
    let (base, api) = server(vec![(200, vec![], "{}"); 3]).await;
    let own = Client::new(&base, "static").unwrap();
    own.execute(request("GET")).await.unwrap();
    let mut c = ClientConfig::new(base.clone(), "static");
    c.user_agent = Some("Peddler/6.0.0 (Language=Ruby; host)".into());
    let wrapped = Client::with_config(c).unwrap();
    wrapped.execute(request("GET")).await.unwrap();
    get_catalog_item(
        &wrapped.with_access_token("other").unwrap(),
        GetCatalogItemParams::new("ASIN".into(), vec!["UK".into()]),
    )
    .await
    .unwrap();
    let requests = api.await.unwrap();
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
    let mut invalid = ClientConfig::new(base, "static");
    invalid.user_agent = Some("bad\r\nvalue".into());
    assert_eq!(
        Client::with_config(invalid).unwrap_err(),
        Error::InvalidRequest
    );
}
