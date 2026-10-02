use peddler::{
    Client, ClientConfig, Error, Request,
    apis::{
        catalog_items_2022_04_01::{GetCatalogItemParams, get_catalog_item},
        tokens_2021_03_01::{CreateRestrictedDataTokenParams, create_restricted_data_token},
    },
};
use std::time::{Duration, Instant};
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
