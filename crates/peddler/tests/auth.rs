use peddler::{
    Client, ClientConfig, Error, Pool, Request,
    auth::{AuthError, LwaClient, LwaTokens, TokenSource},
};
use serde_json::{Value, json};
use std::{sync::Arc, time::Duration};
use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::{TcpListener, TcpStream},
    sync::{Notify, mpsc},
    task::JoinHandle,
};

async fn read_request(stream: &mut TcpStream) -> String {
    let mut bytes = Vec::new();
    loop {
        let mut chunk = [0; 4096];
        let count = stream.read(&mut chunk).await.unwrap();
        assert!(count > 0);
        bytes.extend_from_slice(&chunk[..count]);
        if let Some(end) = bytes.windows(4).position(|part| part == b"\r\n\r\n") {
            let headers = String::from_utf8_lossy(&bytes[..end]).to_ascii_lowercase();
            let length = headers
                .lines()
                .find_map(|line| line.strip_prefix("content-length: ")?.parse::<usize>().ok())
                .unwrap_or(0);
            if bytes.len() >= end + 4 + length {
                return String::from_utf8(bytes).unwrap();
            }
        }
    }
}

async fn server(responses: Vec<(u16, String)>) -> (String, JoinHandle<Vec<String>>) {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let mut requests = Vec::new();
        for (status, body) in responses {
            let (mut stream, _) = listener.accept().await.unwrap();
            requests.push(read_request(&mut stream).await);
            let reply = format!(
                "HTTP/1.1 {status} Test\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{body}",
                body.len()
            );
            stream.write_all(reply.as_bytes()).await.unwrap();
        }
        requests
    });
    (origin, task)
}

fn lwa(origin: &str, timeout: Duration) -> LwaClient {
    LwaClient::with_config("id+&é", "secret+&雪", &format!("{origin}/auth"), timeout).unwrap()
}

/// The three grants share one request path, so every transport rule is checked on each.
#[derive(Clone, Copy, Debug, PartialEq)]
enum Grant {
    Code,
    Refresh,
    Scope,
}
const GRANTS: [Grant; 3] = [Grant::Code, Grant::Refresh, Grant::Scope];
impl Grant {
    async fn request(self, client: &LwaClient) -> Result<LwaTokens, AuthError> {
        match self {
            Self::Code => {
                client
                    .exchange_authorization_code("private-code", None)
                    .await
            }
            Self::Refresh => client.refresh("private-input").await,
            Self::Scope => {
                client
                    .client_credentials("sellingpartnerapi::notifications")
                    .await
            }
        }
    }
}

fn tokens() -> Value {
    json!({"access_token":"private-access","refresh_token":"private-refresh","token_type":"bearer","expires_in":3600})
}

fn get() -> Request {
    Request {
        method: "GET".into(),
        path: "/".into(),
        query: vec![],
        body: None,
    }
}

#[tokio::test]
async fn authorization_code_form_and_tokens_feed_a_refresh_and_a_client() {
    let body = json!({"access_token":"onboard-access","refresh_token":"onboard-refresh","token_type":"bEaReR","expires_in":3600}).to_string();
    let refreshed =
        json!({"access_token":"refreshed-access","token_type":"bearer","expires_in":3600})
            .to_string();
    let (origin, task) = server(vec![(200, body), (200, refreshed), (200, "{}".into())]).await;
    let onboarding = lwa(&origin, Duration::from_secs(2));
    let tokens = onboarding
        .clone()
        .exchange_authorization_code(
            "code+&λ",
            Some("https://app.example/callback?state=a+b&x=雪"),
        )
        .await
        .unwrap();
    assert_eq!(tokens.access_token, "onboard-access");
    assert_eq!(tokens.refresh_token.as_deref(), Some("onboard-refresh"));
    assert_eq!(tokens.token_type, "bEaReR");
    assert_eq!(tokens.expires_in, 3600);
    assert!(!format!("{tokens:?} {onboarding:?}").contains("onboard-access"));
    assert!(!format!("{tokens:?} {onboarding:?}").contains("onboard-refresh"));
    assert!(!format!("{onboarding:?}").contains("secret"));
    let refreshed = onboarding
        .refresh(tokens.refresh_token.as_deref().unwrap())
        .await
        .unwrap();
    let client = Client::new(&origin, &refreshed.access_token).unwrap();
    assert_eq!(client.execute(get()).await.unwrap().status, 200);
    let requests = task.await.unwrap();
    assert_eq!(
        requests[0].split_once("\r\n\r\n").unwrap().1,
        "grant_type=authorization_code&code=code%2B%26%CE%BB&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&redirect_uri=https%3A%2F%2Fapp.example%2Fcallback%3Fstate%3Da%2Bb%26x%3D%E9%9B%AA"
    );
    for request in &requests[..2] {
        assert!(request.starts_with("POST /auth HTTP/1.1\r\n"));
        assert!(request.contains("content-type: application/x-www-form-urlencoded\r\n"));
        assert!(!request.contains("x-amz-access-token:"));
        assert!(!request.contains("x-amz-date:"));
        assert!(!request.contains("authorization:"));
        assert!(!request.contains("accept: application/json"));
    }
    assert!(requests[1].contains("refresh_token=onboard-refresh"));
    assert!(requests[2].contains("x-amz-access-token: refreshed-access"));
}

#[tokio::test]
async fn refresh_form_is_encoded_and_nothing_is_cached() {
    let rotated = tokens().to_string();
    let plain = json!({"access_token":"lwa-secret","token_type":"bEaReR","expires_in":120});
    let (origin, task) = server(vec![(200, plain.to_string()), (200, rotated)]).await;
    let client = lwa(&origin, Duration::from_secs(2));
    let first = client.refresh("refresh+&λ").await.unwrap();
    assert_eq!(first.access_token, "lwa-secret");
    assert_eq!(first.refresh_token, None);
    assert_eq!(first.token_type, "bEaReR");
    assert_eq!(first.expires_in, 120);
    // The helper keeps nothing: the same grant asks LWA again.
    let second = client.clone().refresh("refresh+&λ").await.unwrap();
    assert_eq!(second.access_token, "private-access");
    assert_eq!(second.refresh_token.as_deref(), Some("private-refresh"));
    let requests = task.await.unwrap();
    assert_eq!(requests.len(), 2);
    for request in &requests {
        assert!(request.starts_with("POST /auth HTTP/1.1\r\n"));
        assert!(request.contains("content-type: application/x-www-form-urlencoded\r\n"));
        assert_eq!(
            request.split_once("\r\n\r\n").unwrap().1,
            "grant_type=refresh_token&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&refresh_token=refresh%2B%26%CE%BB"
        );
    }
    let debug = format!("{first:?} {second:?} {client:?}");
    assert!(!debug.contains("secret") && !debug.contains("private"));
}

#[tokio::test]
async fn client_credentials_form_uses_scope() {
    let grantless = json!({"access_token":"grantless","token_type":"bearer","expires_in":2});
    let (origin, task) = server(vec![(200, grantless.to_string())]).await;
    let client = LwaClient::with_config(
        "id",
        "secret",
        &format!("{origin}/auth"),
        Duration::from_secs(2),
    )
    .unwrap();
    let tokens = client
        .client_credentials("sellingpartnerapi::notifications")
        .await
        .unwrap();
    assert_eq!(tokens.access_token, "grantless");
    assert_eq!(tokens.refresh_token, None);
    assert_eq!(tokens.expires_in, 2);
    assert_eq!(
        task.await.unwrap()[0].split_once("\r\n\r\n").unwrap().1,
        "grant_type=client_credentials&client_id=id&client_secret=secret&scope=sellingpartnerapi%3A%3Anotifications"
    );
}

#[tokio::test]
async fn a_shared_pool_reuses_one_connection_and_keeps_the_host_from_lwa() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        let mut requests = Vec::new();
        for body in ["{}".to_owned(), tokens().to_string(), "{}".to_owned()] {
            requests.push(read_request(&mut stream).await);
            let reply = format!(
                "HTTP/1.1 200 OK\r\nContent-Length: {}\r\n\r\n{body}",
                body.len()
            );
            stream.write_all(reply.as_bytes()).await.unwrap();
        }
        // Every request arrived on the first connection.
        assert!(
            tokio::time::timeout(Duration::from_millis(100), listener.accept())
                .await
                .is_err()
        );
        requests
    });
    let pool = Pool::with_user_agent("Peddler/6.0.0 (Language=Ruby)").unwrap();
    let mut config = ClientConfig::new(&origin, "seller-a");
    config.user_agent = Some("Peddler/6.0.0 (Language=Ruby; host)".into());
    config.pool = Some(pool.clone());
    let client = Client::with_config(config).unwrap();
    client.execute(get()).await.unwrap();
    let timeout = Duration::from_secs(2);
    let fresh = LwaClient::with_pool(&pool, "id", "secret", &format!("{origin}/auth"), timeout)
        .unwrap()
        .refresh("refresh")
        .await
        .unwrap();
    let other = client.with_access_token(&fresh.access_token).unwrap();
    other.execute(get()).await.unwrap();
    let requests = task.await.unwrap();
    assert!(requests[0].contains("user-agent: Peddler/6.0.0 (Language=Ruby; host)\r\n"));
    assert!(requests[0].contains("x-amz-access-token: seller-a\r\n"));
    assert!(requests[1].contains("user-agent: Peddler/6.0.0 (Language=Ruby)\r\n"));
    assert!(!requests[1].contains("x-amz-date"));
    assert!(requests[2].contains("user-agent: Peddler/6.0.0 (Language=Ruby; host)\r\n"));
    assert!(requests[2].contains("x-amz-access-token: private-access\r\n"));
    assert_eq!(
        Pool::with_user_agent("bad\r\nvalue").unwrap_err(),
        Error::InvalidRequest
    );
}

#[tokio::test]
async fn validates_inputs_and_every_required_response_field() {
    assert!(LwaClient::new("id", "secret").is_ok());
    let second = Duration::from_secs(1);
    for (id, secret, endpoint, timeout) in [
        ("", "secret", "https://example.com/token", second),
        ("id", " ", "https://example.com/token", second),
        ("id", "secret", "http://example.com/token", second),
        ("id", "secret", "https://private@example.com/token", second),
        ("id", "secret", "https://example.com/token?private", second),
        ("id", "secret", "https://example.com/token#private", second),
        ("id", "secret", "https://example.com\\token", second),
        ("id", "secret", " https://example.com/token", second),
        ("id", "secret", "https://example.com/token", Duration::ZERO),
    ] {
        assert_eq!(
            LwaClient::with_config(id, secret, endpoint, timeout).unwrap_err(),
            AuthError::InvalidConfig,
            "{endpoint}"
        );
    }
    let client = LwaClient::with_config("id", "secret", "http://127.0.0.1:1", second).unwrap();
    for (code, redirect) in [
        ("", None),
        (" ", None),
        ("code", Some("relative")),
        ("code", Some("http:127.0.0.1:1")),
        ("code", Some("http:///127.0.0.1:1")),
        ("code", Some("https://example.com/#private")),
        ("code", Some("https://private@example.com/")),
        ("code", Some("https://example.com/white space")),
    ] {
        assert_eq!(
            client
                .exchange_authorization_code(code, redirect)
                .await
                .unwrap_err(),
            AuthError::InvalidConfig
        );
    }
    for blank in ["", " "] {
        assert_eq!(
            client.refresh(blank).await.unwrap_err(),
            AuthError::InvalidConfig
        );
        assert_eq!(
            client.client_credentials(blank).await.unwrap_err(),
            AuthError::InvalidConfig
        );
    }
    let valid = tokens();
    for grant in GRANTS {
        let mut invalid = vec![];
        for key in ["access_token", "refresh_token", "token_type", "expires_in"] {
            let mut value = valid.clone();
            value.as_object_mut().unwrap().remove(key);
            // Only the authorization code grant must return a refresh token.
            if key == "refresh_token" && grant != Grant::Code {
                let (origin, task) = server(vec![(200, value.to_string())]).await;
                let tokens = grant.request(&lwa(&origin, second)).await.unwrap();
                assert_eq!(tokens.refresh_token, None);
                task.await.unwrap();
            } else {
                invalid.push(value.to_string());
            }
        }
        for (key, bad) in [
            ("access_token", json!("")),
            ("access_token", json!("bad\nvalue")),
            ("refresh_token", json!(" ")),
            ("refresh_token", json!("bad\nvalue")),
            ("token_type", json!("basic")),
            ("expires_in", json!(0)),
            ("expires_in", json!(-1)),
            ("expires_in", json!(1.5)),
            ("expires_in", json!("3600")),
            ("expires_in", json!(u64::MAX)),
        ] {
            let mut value = valid.clone();
            value[key] = bad;
            invalid.push(value.to_string());
        }
        invalid.extend(["private malformed".into(), "x".repeat(64 * 1024 + 1)]);
        for body in invalid {
            let (origin, task) = server(vec![(200, body)]).await;
            let error = grant.request(&lwa(&origin, second)).await.unwrap_err();
            assert_eq!(error, AuthError::InvalidResponse, "{grant:?}");
            assert!(!format!("{error:?} {error}").contains("private"));
            assert!(std::error::Error::source(&error).is_none());
            assert!(!task.await.unwrap()[0].contains("redirect_uri="));
        }
    }
}

#[tokio::test]
async fn rejection_has_no_body_source_retry_or_redirect() {
    for grant in GRANTS {
        for status in [302, 401, 429, 500] {
            let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
            let origin = format!("http://{}", listener.local_addr().unwrap());
            let target = origin.clone();
            let task = tokio::spawn(async move {
                let (mut socket, _) = listener.accept().await.unwrap();
                read_request(&mut socket).await;
                socket.write_all(format!("HTTP/1.1 {status} Test\r\nLocation: {target}/redirect\r\nContent-Length: 12\r\nConnection: close\r\n\r\nprivate-code").as_bytes()).await.unwrap();
                drop(socket);
                assert!(
                    tokio::time::timeout(Duration::from_millis(100), listener.accept())
                        .await
                        .is_err()
                );
            });
            let error = grant
                .request(&lwa(&origin, Duration::from_secs(1)))
                .await
                .unwrap_err();
            assert_eq!(error, AuthError::Rejected { status, code: None });
            assert!(!format!("{error:?} {error}").contains("private"));
            assert!(std::error::Error::source(&error).is_none());
            task.await.unwrap();
        }
    }
}

#[tokio::test]
async fn rejection_names_the_problem_and_keeps_nothing_else() {
    let named = json!({"error":"invalid_client","error_description":"private description"});
    for grant in GRANTS {
        let (origin, task) = server(vec![(401, named.to_string())]).await;
        let error = grant
            .request(&lwa(&origin, Duration::from_secs(1)))
            .await
            .unwrap_err();
        assert_eq!(
            error,
            AuthError::Rejected {
                status: 401,
                code: Some("invalid_client".into())
            }
        );
        assert_eq!(error.to_string(), "authentication rejected (401)");
        assert!(!format!("{error:?} {error}").contains("private"));
        assert!(std::error::Error::source(&error).is_none());
        task.await.unwrap();
    }
    // Only a short lowercase identifier is a code. Anything else is dropped.
    for body in [
        json!({"error":"Invalid_Client"}).to_string(),
        json!({"error":"invalid client"}).to_string(),
        json!({"error":"x".repeat(41)}).to_string(),
        json!({"error":""}).to_string(),
        json!({"error":401}).to_string(),
        json!({"error":["invalid_client"]}).to_string(),
        json!({"error_description":"private"}).to_string(),
        "private not json".into(),
        String::new(),
        "x".repeat(64 * 1024 + 1),
    ] {
        let (origin, task) = server(vec![(400, body)]).await;
        let error = lwa(&origin, Duration::from_secs(1))
            .refresh("private-input")
            .await
            .unwrap_err();
        assert_eq!(
            error,
            AuthError::Rejected {
                status: 400,
                code: None
            }
        );
        assert!(!format!("{error:?} {error}").contains("private"));
        task.await.unwrap();
    }
    let longest = "x".repeat(40);
    let (origin, task) = server(vec![(400, json!({"error": longest}).to_string())]).await;
    let error = lwa(&origin, Duration::from_secs(1))
        .client_credentials("scope")
        .await
        .unwrap_err();
    assert_eq!(
        error,
        AuthError::Rejected {
            status: 400,
            code: Some(longest)
        }
    );
    task.await.unwrap();
}

#[tokio::test]
async fn body_timeout_and_cancellation_close_socket_then_recover() {
    for (grant, cancel) in [
        (Grant::Code, false),
        (Grant::Code, true),
        (Grant::Refresh, false),
        (Grant::Refresh, true),
        (Grant::Scope, true),
    ] {
        let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
        let origin = format!("http://{}", listener.local_addr().unwrap());
        let (started, mut arrived) = mpsc::channel(1);
        let task = tokio::spawn(async move {
            let (mut socket, _) = listener.accept().await.unwrap();
            read_request(&mut socket).await;
            socket
                .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 1000\r\n\r\n{")
                .await
                .unwrap();
            started.send(()).await.unwrap();
            let mut byte = [0];
            let read = tokio::time::timeout(Duration::from_secs(2), socket.read(&mut byte))
                .await
                .unwrap();
            // Client drop yields EOF if receive buffer was drained or ConnectionReset if unread bytes remained.
            match read {
                Ok(0) => {}
                Err(err) if err.kind() == std::io::ErrorKind::ConnectionReset => {}
                other => panic!("expected EOF or ConnectionReset on teardown, got {other:?}"),
            }
            let (mut socket, _) = listener.accept().await.unwrap();
            read_request(&mut socket).await;
            let body = tokens().to_string();
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
        let client = lwa(
            &origin,
            Duration::from_millis(if cancel { 2000 } else { 500 }),
        );
        let pending = client.clone();
        let call = tokio::spawn(async move { grant.request(&pending).await });
        arrived.recv().await.unwrap();
        if cancel {
            call.abort();
            assert!(call.await.unwrap_err().is_cancelled());
        } else {
            assert_eq!(call.await.unwrap().unwrap_err(), AuthError::Timeout);
        }
        assert_eq!(
            grant.request(&client).await.unwrap().access_token,
            "private-access"
        );
        task.await.unwrap();
    }
}

struct GatedServer {
    origin: String,
    requests: mpsc::UnboundedReceiver<String>,
    task: JoinHandle<()>,
}
impl Drop for GatedServer {
    fn drop(&mut self) {
        self.task.abort();
    }
}

async fn gated_server(responses: Vec<(u16, String, Option<Arc<Notify>>)>) -> GatedServer {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let (sender, requests) = mpsc::unbounded_channel();
    let task = tokio::spawn(async move {
        let mut responses = responses.into_iter();
        let mut handlers = tokio::task::JoinSet::new();
        loop {
            let (mut stream, _) = listener.accept().await.unwrap();
            let (status, body, gate) =
                responses
                    .next()
                    .unwrap_or((500, "unexpected request".into(), None));
            let sender = sender.clone();
            handlers.spawn(async move {
                sender.send(read_request(&mut stream).await).unwrap();
                if let Some(gate) = gate { gate.notified().await; }
                let reply = format!("HTTP/1.1 {status} Test\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{body}", body.len());
                let _ = stream.write_all(reply.as_bytes()).await;
            });
            while handlers.try_join_next().is_some() {}
        }
    });
    GatedServer {
        origin,
        requests,
        task,
    }
}

fn reply(token: &str, expiry: u64) -> String {
    json!({"access_token":token,"token_type":"bEaReR","expires_in":expiry}).to_string()
}

fn refresh_source(origin: &str) -> TokenSource {
    lwa(origin, Duration::from_secs(2))
        .source_for_refresh_token("refresh+&λ")
        .unwrap()
}

#[tokio::test]
async fn source_clones_share_one_cached_token_and_show_no_secret() {
    let (origin, task) = server(vec![(200, reply("lwa-secret", 120))]).await;
    let source = refresh_source(&origin);
    assert_eq!(source.token().await.unwrap(), "lwa-secret");
    assert_eq!(source.clone().token().await.unwrap(), "lwa-secret");
    let requests = task.await.unwrap();
    assert_eq!(requests.len(), 1);
    assert_eq!(
        requests[0].split_once("\r\n\r\n").unwrap().1,
        "grant_type=refresh_token&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&refresh_token=refresh%2B%26%CE%BB"
    );
    let debug = format!("{source:?}");
    assert!(!debug.contains("secret") && !debug.contains("refresh+"));
}

#[tokio::test]
async fn scope_source_uses_client_credentials_and_rejects_blank_input() {
    let (origin, task) = server(vec![(200, reply("grantless", 120))]).await;
    let client = lwa(&origin, Duration::from_secs(2));
    let source = client
        .source_for_scope("sellingpartnerapi::notifications")
        .unwrap();
    assert_eq!(source.token().await.unwrap(), "grantless");
    assert_eq!(source.token().await.unwrap(), "grantless");
    assert!(
        task.await.unwrap()[0]
            .ends_with("grant_type=client_credentials&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&scope=sellingpartnerapi%3A%3Anotifications")
    );
    for blank in ["", " "] {
        assert_eq!(
            client.source_for_refresh_token(blank).unwrap_err(),
            AuthError::InvalidConfig
        );
        assert_eq!(
            client.source_for_scope(blank).unwrap_err(),
            AuthError::InvalidConfig
        );
    }
}

#[tokio::test]
async fn source_coalesces_success_and_failure_without_retrying() {
    let rejected = AuthError::Rejected {
        status: 401,
        code: Some("invalid_grant".into()),
    };
    for (status, body, expected) in [
        (200, reply("shared", 120), Ok("shared")),
        (
            401,
            json!({"error":"invalid_grant","error_description":"secret rejected body"}).to_string(),
            Err(rejected),
        ),
    ] {
        let gate = Arc::new(Notify::new());
        let mut server = gated_server(vec![(status, body, Some(gate.clone()))]).await;
        let source = refresh_source(&server.origin);
        let mut callers = Vec::new();
        for _ in 0..16 {
            let source = source.clone();
            callers.push(tokio::spawn(async move { source.token().await }));
        }
        server.requests.recv().await.unwrap();
        for _ in 0..32 {
            tokio::task::yield_now().await;
        }
        gate.notify_one();
        for caller in callers {
            let result = caller.await.unwrap();
            match &expected {
                Ok(value) => assert_eq!(result.unwrap(), *value),
                Err(error) => assert_eq!(result.unwrap_err(), *error),
            }
        }
        assert!(server.requests.try_recv().is_err());
    }
}

#[tokio::test]
async fn source_failure_is_not_cached_and_the_next_call_recovers() {
    let (origin, task) = server(vec![
        (401, json!({"error":"invalid_grant"}).to_string()),
        (200, reply("recovered", 120)),
    ])
    .await;
    let source = refresh_source(&origin);
    assert_eq!(
        source.token().await.unwrap_err(),
        AuthError::Rejected {
            status: 401,
            code: Some("invalid_grant".into())
        }
    );
    assert_eq!(source.token().await.unwrap(), "recovered");
    assert_eq!(source.token().await.unwrap(), "recovered");
    assert_eq!(task.await.unwrap().len(), 2);
}

#[tokio::test]
async fn source_cancelled_waiters_preserve_refresh_and_all_waiters_can_recover() {
    for cancel_all in [false, true] {
        let gate = Arc::new(Notify::new());
        let mut responses = vec![(200, reply("recovered", 120), Some(gate.clone()))];
        if cancel_all {
            responses.push((200, reply("recovered", 120), None));
        }
        let mut server = gated_server(responses).await;
        let source = refresh_source(&server.origin);
        let first_source = source.clone();
        let first = tokio::spawn(async move { first_source.token().await });
        server.requests.recv().await.unwrap();
        let next_source = source.clone();
        let mut next = tokio::spawn(async move { next_source.token().await });
        tokio::task::yield_now().await;
        first.abort();
        let _ = first.await;
        if cancel_all {
            next.abort();
            let _ = next.await;
            let next_source = source.clone();
            next = tokio::spawn(async move { next_source.token().await });
        }
        gate.notify_one();
        assert_eq!(next.await.unwrap().unwrap(), "recovered");
        assert_eq!(source.token().await.unwrap(), "recovered");
        if cancel_all {
            server.requests.recv().await.unwrap();
        }
        assert!(server.requests.try_recv().is_err());
    }
}

#[tokio::test]
async fn source_cancellation_by_the_last_waiter_closes_the_socket() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let (started, waiting) = tokio::sync::oneshot::channel();
    let server = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        read_request(&mut socket).await;
        started.send(()).unwrap();
        let mut byte = [0];
        assert_eq!(
            socket.read(&mut byte).await.unwrap(),
            0,
            "cancellation must close the socket"
        );
        let (mut socket, _) = listener.accept().await.unwrap();
        read_request(&mut socket).await;
        let body = reply("recovered", 120);
        let reply = format!(
            "HTTP/1.1 200 OK\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{body}",
            body.len()
        );
        socket.write_all(reply.as_bytes()).await.unwrap();
    });
    let source = refresh_source(&origin);
    let pending = source.clone();
    let call = tokio::spawn(async move { pending.token().await });
    waiting.await.unwrap();
    call.abort();
    assert!(call.await.unwrap_err().is_cancelled());
    assert_eq!(source.token().await.unwrap(), "recovered");
    server.await.unwrap();
}

#[tokio::test]
async fn source_refreshes_short_lifetimes_early_and_never_reuses_an_expired_token() {
    let (origin, task) = server(vec![
        (200, reply("first", 10)),
        (200, reply("second", 10)),
        (200, reply("third", 10)),
    ])
    .await;
    let source = refresh_source(&origin);
    assert_eq!(source.token().await.unwrap(), "first");
    tokio::time::pause();
    tokio::time::advance(Duration::from_secs(8)).await;
    assert_eq!(source.token().await.unwrap(), "first");
    tokio::time::advance(Duration::from_secs(1)).await;
    tokio::time::resume();
    assert_eq!(source.token().await.unwrap(), "second");
    tokio::time::pause();
    tokio::time::advance(Duration::from_secs(11)).await;
    tokio::time::resume();
    assert_eq!(source.token().await.unwrap(), "third");
    assert_eq!(task.await.unwrap().len(), 3);
}

#[tokio::test]
async fn source_refreshes_long_lifetimes_60_seconds_early() {
    let (origin, task) = server(vec![
        (200, reply("first", 1200)),
        (200, reply("second", 1200)),
    ])
    .await;
    let source = refresh_source(&origin);
    assert_eq!(source.token().await.unwrap(), "first");
    tokio::time::pause();
    tokio::time::advance(Duration::from_secs(1139)).await;
    assert_eq!(source.token().await.unwrap(), "first");
    tokio::time::advance(Duration::from_secs(1)).await;
    tokio::time::resume();
    assert_eq!(source.token().await.unwrap(), "second");
    assert_eq!(task.await.unwrap().len(), 2);
}

#[tokio::test]
async fn source_lifetimes_begin_before_the_request_finishes() {
    let gate = Arc::new(Notify::new());
    let mut server = gated_server(vec![
        (200, reply("already-expired", 1), Some(gate.clone())),
        (200, reply("fresh", 120), None),
    ])
    .await;
    let source = refresh_source(&server.origin);
    let pending = source.clone();
    let first = tokio::spawn(async move { pending.token().await });
    server.requests.recv().await.unwrap();
    tokio::time::pause();
    tokio::time::advance(Duration::from_millis(1100)).await;
    tokio::time::resume();
    gate.notify_one();
    assert_eq!(
        first.await.unwrap().unwrap_err(),
        AuthError::InvalidResponse
    );
    assert_eq!(source.token().await.unwrap(), "fresh");
}

#[tokio::test]
async fn lifetimes_begin_before_the_request_finishes() {
    let gate = Arc::new(Notify::new());
    let expired = json!({"access_token":"already-expired","token_type":"bearer","expires_in":1});
    let mut server = gated_server(vec![
        (200, expired.to_string(), Some(gate.clone())),
        (200, tokens().to_string(), None),
    ])
    .await;
    let client = lwa(&server.origin, Duration::from_secs(2));
    let pending = client.clone();
    let first = tokio::spawn(async move { pending.refresh("refresh").await });
    server.requests.recv().await.unwrap();
    tokio::time::pause();
    tokio::time::advance(Duration::from_millis(1100)).await;
    tokio::time::resume();
    gate.notify_one();
    assert_eq!(
        first.await.unwrap().unwrap_err(),
        AuthError::InvalidResponse
    );
    assert_eq!(
        client.refresh("refresh").await.unwrap().access_token,
        "private-access"
    );
}

#[tokio::test]
async fn response_limit_applies_to_fixed_length_and_chunked_bodies() {
    for (length, expected) in [
        (65536, Ok("private-access")),
        (65537, Err(AuthError::InvalidResponse)),
    ] {
        let mut body = tokens().to_string();
        body.extend(std::iter::repeat_n(' ', length - body.len()));
        let (origin, task) = server(vec![(200, body)]).await;
        let result = lwa(&origin, Duration::from_secs(2))
            .refresh("refresh")
            .await;
        match expected {
            Ok(value) => assert_eq!(result.unwrap().access_token, value),
            Err(error) => assert_eq!(result.unwrap_err(), error),
        }
        task.await.unwrap();
    }
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        read_request(&mut stream).await;
        stream
            .write_all(b"HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n\r\n")
            .await
            .unwrap();
        let body = "x".repeat(32768);
        for _ in 0..3 {
            let chunk = format!("8000\r\n{body}\r\n");
            if stream.write_all(chunk.as_bytes()).await.is_err() {
                return;
            }
        }
        let _ = stream.write_all(b"0\r\n\r\n").await;
    });
    assert_eq!(
        lwa(&origin, Duration::from_secs(2))
            .client_credentials("scope")
            .await
            .unwrap_err(),
        AuthError::InvalidResponse
    );
    task.await.unwrap();
}

#[tokio::test]
async fn transport_errors_and_timeouts_never_retain_urls_or_secrets() {
    let gate = Arc::new(Notify::new());
    let mut server = gated_server(vec![(200, tokens().to_string(), Some(gate))]).await;
    let endpoint = format!("{}/auth-secret", server.origin);
    let client =
        LwaClient::with_config("id", "secret", &endpoint, Duration::from_millis(20)).unwrap();
    let error = client.refresh("refresh-secret").await.unwrap_err();
    assert_eq!(error, AuthError::Timeout);
    assert!(
        server
            .requests
            .recv()
            .await
            .unwrap()
            .starts_with("POST /auth-secret ")
    );
    assert!(!format!("{error} {error:?}").contains("secret"));
    assert!(!format!("{error} {error:?}").contains(&server.origin));
    assert!(std::error::Error::source(&error).is_none());
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        read_request(&mut stream).await;
    });
    let endpoint = format!("{origin}/auth-secret");
    let client = LwaClient::with_config("id", "secret", &endpoint, Duration::from_secs(2)).unwrap();
    let error = client.refresh("refresh-secret").await.unwrap_err();
    assert_eq!(error, AuthError::Transport);
    assert!(!format!("{error} {error:?}").contains("secret"));
    assert!(std::error::Error::source(&error).is_none());
    task.await.unwrap();
}
