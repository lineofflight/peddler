use peddler::{
    Client, ClientConfig, Error, Request,
    apis::catalog_items_2022_04_01::{GetCatalogItemParams, get_catalog_item},
    auth::{Credentials, RestrictedResource, RestrictedScope},
    policy::RateLimit,
};
use std::time::Duration;
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
fn config(base: String, lwa: String) -> ClientConfig {
    let mut c = ClientConfig::new(
        base,
        Credentials::RefreshToken {
            client_id: "dummy-id".into(),
            client_secret: "dummy-secret".into(),
            refresh_token: "dummy-refresh".into(),
        },
    );
    c.lwa_endpoint = lwa;
    c
}
#[tokio::test]
async fn raw_generated_and_concurrent_clones_share_one_refresh() {
    let (lwa, auth) = server(vec![(
        200,
        vec![],
        r#"{"access_token":"fresh-token","token_type":"bearer","expires_in":3600}"#,
    )])
    .await;
    let (base, api) = server(vec![(200, vec![], "{}"); 8]).await;
    let client = Client::with_config(config(base, lwa)).unwrap();
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
async fn retry_safe_get_but_never_patch_and_keep_final_response() {
    let (base, api) = server(vec![
        (429, vec![("Retry-After", "0")], "first"),
        (200, vec![], "ok"),
        (429, vec![("x-repeat", "a"), ("x-repeat", "b")], "last"),
    ])
    .await;
    let mut c = ClientConfig::new(base, Credentials::AccessToken("static".into()));
    c.policy.retry.max_retries = 2;
    let client = Client::with_config(c).unwrap();
    assert_eq!(client.execute(request("GET")).await.unwrap().body, b"ok");
    let final_response = client.execute(request("PATCH")).await.unwrap();
    assert_eq!(final_response.body, b"last");
    assert_eq!(final_response.status, 429);
    assert_eq!(api.await.unwrap().len(), 3);
}
#[tokio::test]
async fn deadline_includes_rate_wait_and_excessive_backoff_returns_last_response() {
    let (base, api) = server(vec![
        (200, vec![], "ok"),
        (429, vec![("Retry-After", "1")], "retain"),
    ])
    .await;
    let mut c = ClientConfig::new(base, Credentials::AccessToken("static".into()));
    c.timeout = Duration::from_millis(50);
    c.policy.retry.max_retries = 1;
    c.policy.rate_limits.insert(
        "slow".into(),
        RateLimit {
            rate_per_second: 0.1,
            burst: 1,
        },
    );
    let client = Client::with_config(c).unwrap();
    client
        .execute_with_operation("slow", request("GET"))
        .await
        .unwrap();
    assert_eq!(
        client
            .execute_with_operation("slow", request("GET"))
            .await
            .unwrap_err(),
        Error::Timeout
    );
    assert_eq!(
        client.execute(request("GET")).await.unwrap().body,
        b"retain"
    );
    api.await.unwrap();
}
#[tokio::test]
async fn restricted_views_reuse_canonical_tokens_and_base_bootstrap() {
    let (base, api) = server(vec![
        (
            200,
            vec![],
            r#"{"restrictedDataToken":"rdt-one","expiresIn":3600}"#,
        ),
        (200, vec![], "ok"),
        (200, vec![], "ok"),
        (
            200,
            vec![],
            r#"{"restrictedDataToken":"rdt-two","expiresIn":3600}"#,
        ),
        (200, vec![], "ok"),
    ])
    .await;
    let client = Client::new(&base, "base-token").unwrap();
    let scope = RestrictedScope {
        resources: vec![RestrictedResource {
            method: "GET".into(),
            path: "/test".into(),
            data_elements: vec![],
        }],
        target_application: None,
    };
    client
        .restricted(scope.clone())
        .unwrap()
        .execute(request("GET"))
        .await
        .unwrap();
    client
        .restricted(scope.clone())
        .unwrap()
        .execute(request("GET"))
        .await
        .unwrap();
    let mut other = scope;
    other.target_application = Some("other-app".into());
    client
        .restricted(other)
        .unwrap()
        .execute(request("GET"))
        .await
        .unwrap();
    let requests = api.await.unwrap();
    assert!(requests[0].contains("x-amz-access-token: base-token"));
    assert!(requests[3].contains("x-amz-access-token: base-token"));
    assert!(requests[1].contains("x-amz-access-token: rdt-one"));
    assert!(requests[2].contains("x-amz-access-token: rdt-one"));
    assert!(requests[4].contains("x-amz-access-token: rdt-two"));
}
#[tokio::test]
async fn invalid_input_does_not_fetch_tokens_and_failed_refresh_recovers() {
    let (lwa, auth) = server(vec![
        (401, vec![], "dummy-secret"),
        (
            200,
            vec![],
            r#"{"access_token":"recovered","token_type":"bearer","expires_in":3600}"#,
        ),
    ])
    .await;
    let (base, api) = server(vec![(200, vec![], "ok")]).await;
    let client = Client::with_config(config(base, lwa)).unwrap();
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
    assert_eq!(
        client
            .execute_with_operation("", request("GET"))
            .await
            .unwrap_err(),
        Error::InvalidRequest
    );
    let err = client.execute(request("GET")).await.unwrap_err();
    assert!(matches!(err, Error::Authentication(_)));
    assert!(!format!("{err:?}").contains("dummy-secret"));
    client.execute(request("GET")).await.unwrap();
    assert_eq!(auth.await.unwrap().len(), 2);
    api.await.unwrap();
}

#[tokio::test]
async fn token_is_refreshed_after_rate_wait_and_retry_backoff() {
    let token1 = r#"{"access_token":"first","token_type":"bearer","expires_in":1}"#;
    let token2 = r#"{"access_token":"second","token_type":"bearer","expires_in":3600}"#;
    let (lwa, auth) = server(vec![(200, vec![], token1), (200, vec![], token2)]).await;
    let (base, api) = server(vec![
        (429, vec![("Retry-After", "1")], "retry"),
        (200, vec![], "ok"),
    ])
    .await;
    let mut c = config(base, lwa);
    c.policy.retry.max_retries = 1;
    c.policy.rate_limits.insert(
        "raw".into(),
        RateLimit {
            rate_per_second: 1.0,
            burst: 1,
        },
    );
    let client = Client::with_config(c).unwrap();
    client.execute(request("GET")).await.unwrap();
    assert_eq!(auth.await.unwrap().len(), 2);
    let requests = api.await.unwrap();
    assert!(requests[0].contains("x-amz-access-token: first"));
    assert!(requests[1].contains("x-amz-access-token: second"));
}
#[tokio::test]
async fn rate_wait_refreshes_expired_token_and_other_operations_are_independent() {
    let (lwa, auth) = server(vec![
        (
            200,
            vec![],
            r#"{"access_token":"first","token_type":"bearer","expires_in":1}"#,
        ),
        (
            200,
            vec![],
            r#"{"access_token":"second","token_type":"bearer","expires_in":3600}"#,
        ),
    ])
    .await;
    let (base, api) = server(vec![(200, vec![], "ok"); 3]).await;
    let mut c = config(base, lwa);
    c.policy.rate_limits.insert(
        "slow".into(),
        RateLimit {
            rate_per_second: 0.9,
            burst: 1,
        },
    );
    let client = Client::with_config(c).unwrap();
    client
        .execute_with_operation("slow", request("GET"))
        .await
        .unwrap();
    tokio::time::timeout(
        Duration::from_millis(100),
        client.execute_with_operation("separate", request("GET")),
    )
    .await
    .unwrap()
    .unwrap();
    client
        .execute_with_operation("slow", request("GET"))
        .await
        .unwrap();
    let requests = api.await.unwrap();
    assert!(requests[2].contains("x-amz-access-token: second"));
    assert_eq!(auth.await.unwrap().len(), 2);
}
#[tokio::test]
async fn cancelled_refresh_closes_socket_and_recovers() {
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
        let body = r#"{"access_token":"recovered","token_type":"bearer","expires_in":3600}"#;
        socket
            .write_all(
                format!(
                    "HTTP/1.1 200 OK\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{body}",
                    body.len()
                )
                .as_bytes(),
            )
            .await
            .unwrap();
    });
    let (base, api) = server(vec![(200, vec![], "ok")]).await;
    let client = Client::with_config(config(base, lwa)).unwrap();
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
async fn overall_deadline_cancels_auth_socket() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let lwa = format!("http://{}", listener.local_addr().unwrap());
    let auth = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        let mut buf = [0; 4096];
        assert!(socket.read(&mut buf).await.unwrap() > 0);
        assert_eq!(socket.read(&mut buf).await.unwrap(), 0);
    });
    let mut c = config("http://127.0.0.1:1".into(), lwa);
    c.timeout = Duration::from_millis(30);
    let client = Client::with_config(c).unwrap();
    assert_eq!(
        client.execute(request("GET")).await.unwrap_err(),
        Error::Timeout
    );
    auth.await.unwrap();
}

#[tokio::test]
async fn generated_get_uses_retry_policy_and_retains_final_error() {
    let (base, api) = server(vec![
        (429, vec![("Retry-After", "0")], "first"),
        (200, vec![], "{}"),
        (503, vec![("Retry-After", "2")], "unparsed"),
    ])
    .await;
    let mut c = ClientConfig::new(base, Credentials::AccessToken("static".into()));
    c.policy.retry.max_retries = 1;
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
