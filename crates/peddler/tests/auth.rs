use peddler::auth::{
    AuthError, AuthManager, Credentials, LwaClient, RestrictedResource, RestrictedScope,
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

fn http() -> reqwest::Client {
    reqwest::Client::builder()
        .redirect(reqwest::redirect::Policy::none())
        .retry(reqwest::retry::never())
        .timeout(Duration::from_secs(2))
        .user_agent("auth-supplied-client")
        .build()
        .unwrap()
}

fn refresh() -> Credentials {
    Credentials::RefreshToken {
        client_id: "id+&é".into(),
        client_secret: "secret+&雪".into(),
        refresh_token: "refresh+&λ".into(),
    }
}

fn scope(path: &str) -> RestrictedScope {
    RestrictedScope {
        resources: vec![RestrictedResource {
            method: "GET".into(),
            path: path.into(),
            data_elements: vec!["shippingAddress".into()],
        }],
        target_application: None,
    }
}

fn lwa(token: &str, expiry: u64) -> String {
    json!({"access_token":token,"token_type":"bEaReR","expires_in":expiry}).to_string()
}

#[tokio::test]
async fn onboarding_exact_form_and_tokens_support_managed_refresh() {
    let body = json!({"access_token":"onboard-access","refresh_token":"onboard-refresh","token_type":"bEaReR","expires_in":3600}).to_string();
    let (origin, task) = server(vec![
        (200, body),
        (200, lwa("managed-access", 3600)),
        (200, "{}".into()),
    ])
    .await;
    let onboarding = LwaClient::with_config(
        "id+&é",
        "secret+&雪",
        &format!("{origin}/auth"),
        Duration::from_secs(2),
    )
    .unwrap();
    let tokens = onboarding
        .clone()
        .exchange_authorization_code(
            "code+&λ",
            Some("https://app.example/callback?state=a+b&x=雪"),
        )
        .await
        .unwrap();
    assert_eq!(tokens.access_token, "onboard-access");
    assert_eq!(tokens.refresh_token, "onboard-refresh");
    assert_eq!(tokens.token_type, "bEaReR");
    assert_eq!(tokens.expires_in, 3600);
    assert!(!format!("{tokens:?} {onboarding:?}").contains("onboard-access"));
    assert!(!format!("{tokens:?} {onboarding:?}").contains("onboard-refresh"));
    assert!(!format!("{onboarding:?}").contains("secret"));
    let mut config = peddler::ClientConfig::new(
        &origin,
        Credentials::RefreshToken {
            client_id: "id".into(),
            client_secret: "secret".into(),
            refresh_token: tokens.refresh_token,
        },
    );
    config.lwa_endpoint = format!("{origin}/auth");
    let client = peddler::Client::with_config(config).unwrap();
    assert_eq!(
        client
            .execute(peddler::Request {
                method: "GET".into(),
                path: "/".into(),
                query: vec![],
                body: None
            })
            .await
            .unwrap()
            .status,
        200
    );
    let requests = task.await.unwrap();
    assert_eq!(
        requests[0].split_once("\r\n\r\n").unwrap().1,
        "grant_type=authorization_code&code=code%2B%26%CE%BB&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&redirect_uri=https%3A%2F%2Fapp.example%2Fcallback%3Fstate%3Da%2Bb%26x%3D%E9%9B%AA"
    );
    assert!(!requests[0].contains("x-amz-access-token:"));
    assert!(!requests[0].contains("authorization:"));
    assert!(!requests[0].contains("accept: application/json"));
    assert!(requests[1].contains("refresh_token=onboard-refresh"));
    assert!(requests[2].contains("x-amz-access-token: managed-access"));
}

fn onboarding_body() -> Value {
    json!({"access_token":"private-access","refresh_token":"private-refresh","token_type":"bearer","expires_in":3600})
}

#[tokio::test]
async fn onboarding_validates_inputs_and_every_required_response_field() {
    assert!(LwaClient::new("id", "secret").is_ok());
    for (id, secret, endpoint, timeout) in [
        (
            "",
            "secret",
            "https://example.com/token",
            Duration::from_secs(1),
        ),
        (
            "id",
            " ",
            "https://example.com/token",
            Duration::from_secs(1),
        ),
        (
            "id",
            "secret",
            "http://example.com/token",
            Duration::from_secs(1),
        ),
        (
            "id",
            "secret",
            "https://private@example.com/token",
            Duration::from_secs(1),
        ),
        (
            "id",
            "secret",
            "https://example.com/token?private",
            Duration::from_secs(1),
        ),
        ("id", "secret", "https://example.com/token", Duration::ZERO),
    ] {
        assert_eq!(
            LwaClient::with_config(id, secret, endpoint, timeout).unwrap_err(),
            AuthError::InvalidConfig
        );
    }
    let client =
        LwaClient::with_config("id", "secret", "http://127.0.0.1:1", Duration::from_secs(1))
            .unwrap();
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
    let valid = onboarding_body();
    let mut invalid = vec![];
    for key in ["access_token", "refresh_token", "token_type", "expires_in"] {
        let mut value = valid.clone();
        value.as_object_mut().unwrap().remove(key);
        invalid.push(value.to_string());
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
        let client =
            LwaClient::with_config("id", "secret", &origin, Duration::from_secs(1)).unwrap();
        let error = client
            .exchange_authorization_code("private-code", None)
            .await
            .unwrap_err();
        assert_eq!(error, AuthError::InvalidResponse);
        assert!(!format!("{error:?} {error}").contains("private"));
        assert!(std::error::Error::source(&error).is_none());
        assert!(!task.await.unwrap()[0].contains("redirect_uri="));
    }
}

#[tokio::test]
async fn onboarding_rejection_has_no_body_source_retry_or_redirect() {
    for status in [302, 429, 500] {
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
        let client =
            LwaClient::with_config("id", "secret", &origin, Duration::from_secs(1)).unwrap();
        let error = client
            .exchange_authorization_code("private-code", None)
            .await
            .unwrap_err();
        assert_eq!(error, AuthError::Rejected(status));
        assert!(!format!("{error:?} {error}").contains("private"));
        assert!(std::error::Error::source(&error).is_none());
        task.await.unwrap();
    }
}

#[tokio::test]
async fn onboarding_body_timeout_and_cancellation_close_socket_then_recover() {
    for cancel in [false, true] {
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
            let body = onboarding_body().to_string();
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
        let client = LwaClient::with_config(
            "id",
            "secret",
            &origin,
            Duration::from_millis(if cancel { 2000 } else { 500 }),
        )
        .unwrap();
        let pending = client.clone();
        let call =
            tokio::spawn(async move { pending.exchange_authorization_code("code", None).await });
        arrived.recv().await.unwrap();
        if cancel {
            call.abort();
            assert!(call.await.unwrap_err().is_cancelled());
        } else {
            assert_eq!(call.await.unwrap().unwrap_err(), AuthError::Timeout);
        }
        assert_eq!(
            client
                .exchange_authorization_code("new-code", None)
                .await
                .unwrap()
                .refresh_token,
            "private-refresh"
        );
        task.await.unwrap();
    }
}

fn rdt(token: &str, expiry: u64) -> String {
    json!({"restrictedDataToken":token,"expiresIn":expiry}).to_string()
}

#[tokio::test]
async fn refresh_form_is_encoded_and_clones_cache_sensitive_tokens() {
    let (origin, task) = server(vec![(200, lwa("lwa-secret", 120))]).await;
    let manager = AuthManager::new(http(), &origin, refresh(), &format!("{origin}/auth")).unwrap();
    let token = manager.token(None).await.unwrap();
    assert_eq!(token, "lwa-secret");
    assert!(token.is_sensitive());
    assert_eq!(manager.clone().token(None).await.unwrap(), token);
    let requests = task.await.unwrap();
    assert!(requests[0].starts_with("POST /auth HTTP/1.1\r\n"));
    assert!(requests[0].contains("user-agent: auth-supplied-client\r\n"));
    assert!(requests[0].contains("content-type: application/x-www-form-urlencoded\r\n"));
    assert_eq!(
        requests[0].split_once("\r\n\r\n").unwrap().1,
        "grant_type=refresh_token&client_id=id%2B%26%C3%A9&client_secret=secret%2B%26%E9%9B%AA&refresh_token=refresh%2B%26%CE%BB"
    );
    assert!(!format!("{manager:?}").contains("secret"));
    assert!(!format!("{:?}", refresh()).contains("secret"));
}

#[tokio::test]
async fn client_credentials_form_uses_scope() {
    let (origin, task) = server(vec![(200, lwa("grantless", 2))]).await;
    let credentials = Credentials::ClientCredentials {
        client_id: "id".into(),
        client_secret: "secret".into(),
        scope: "sellingpartnerapi::notifications".into(),
    };
    let manager =
        AuthManager::new(http(), &origin, credentials, &format!("{origin}/auth")).unwrap();
    assert_eq!(manager.token(None).await.unwrap(), "grantless");
    assert_eq!(
        task.await.unwrap()[0].split_once("\r\n\r\n").unwrap().1,
        "grant_type=client_credentials&client_id=id&client_secret=secret&scope=sellingpartnerapi%3A%3Anotifications"
    );
}

#[tokio::test]
async fn rdt_bootstrap_uses_lwa_and_canonical_scope_identity() {
    let (origin, task) = server(vec![
        (200, lwa("lwa-secret", 120)),
        (200, rdt("rdt-one", 120)),
        (200, rdt("rdt-two", 120)),
    ])
    .await;
    let manager = AuthManager::new(http(), &origin, refresh(), &format!("{origin}/auth")).unwrap();
    let mut first = scope("/orders/{orderId}/address");
    first.resources[0].data_elements = vec![
        "buyerInfo".into(),
        "shippingAddress".into(),
        "buyerInfo".into(),
    ];
    first.resources.push(first.resources[0].clone());
    first.resources.push(RestrictedResource {
        method: "POST".into(),
        path: "/orders/{orderId}/buyer".into(),
        data_elements: vec![],
    });
    assert_eq!(manager.token(Some(&first)).await.unwrap(), "rdt-one");
    let mut same = first.clone();
    same.resources.reverse();
    same.resources[0].data_elements.reverse();
    assert_eq!(manager.token(Some(&same)).await.unwrap(), "rdt-one");
    same.target_application = Some("application".into());
    assert_eq!(manager.token(Some(&same)).await.unwrap(), "rdt-two");
    let requests = task.await.unwrap();
    for request in &requests[1..] {
        assert!(request.starts_with("POST /tokens/2021-03-01/restrictedDataToken HTTP/1.1\r\n"));
        assert!(request.contains("x-amz-access-token: lwa-secret\r\n"));
        assert!(!request.contains("rdt-one"));
    }
    assert_eq!(
        serde_json::from_str::<Value>(requests[1].split_once("\r\n\r\n").unwrap().1).unwrap(),
        json!({"restrictedResources":[{"method":"GET","path":"/orders/{orderId}/address","dataElements":["buyerInfo","shippingAddress"]},{"method":"POST","path":"/orders/{orderId}/buyer","dataElements":[]}]})
    );
    assert_eq!(
        serde_json::from_str::<Value>(requests[2].split_once("\r\n\r\n").unwrap().1).unwrap()["targetApplication"],
        "application"
    );
}

#[tokio::test]
async fn static_token_supports_rdt() {
    let (origin, task) = server(vec![(200, rdt("restricted", 120))]).await;
    let manager = AuthManager::new(
        http(),
        &origin,
        Credentials::AccessToken("static-secret".into()),
        "https://api.amazon.com/auth/o2/token",
    )
    .unwrap();
    assert_eq!(manager.token(None).await.unwrap(), "static-secret");
    assert_eq!(
        manager.token(Some(&scope("/orders"))).await.unwrap(),
        "restricted"
    );
    assert!(task.await.unwrap()[0].contains("x-amz-access-token: static-secret\r\n"));
}

#[tokio::test]
async fn rejects_invalid_configuration_before_network() {
    for origin in [
        "http://example.com",
        "https://user@example.com",
        "https://example.com/path",
        "https://example.com?x",
        "https://example.com#x",
        "https://example.com/../",
        "https://example.com\\",
        " https://example.com",
    ] {
        assert_eq!(
            AuthManager::new(
                http(),
                origin,
                refresh(),
                "https://api.amazon.com/auth/o2/token"
            )
            .unwrap_err(),
            AuthError::InvalidConfig,
            "{origin}"
        );
    }
    for endpoint in [
        "http://example.com/auth",
        "https://user@example.com/auth",
        "https://example.com/auth?x",
        "https://example.com/auth#x",
        "https://example.com\\auth",
    ] {
        assert_eq!(
            AuthManager::new(http(), "https://example.com", refresh(), endpoint).unwrap_err(),
            AuthError::InvalidConfig,
            "{endpoint}"
        );
    }
    for credentials in [
        Credentials::AccessToken("".into()),
        Credentials::AccessToken("secret\n".into()),
        Credentials::RefreshToken {
            client_id: "".into(),
            client_secret: "secret".into(),
            refresh_token: "refresh".into(),
        },
        Credentials::ClientCredentials {
            client_id: "id".into(),
            client_secret: "secret".into(),
            scope: "".into(),
        },
    ] {
        assert_eq!(
            AuthManager::new(
                http(),
                "https://example.com",
                credentials,
                "https://api.amazon.com/auth/o2/token"
            )
            .unwrap_err(),
            AuthError::InvalidConfig
        );
    }
}

#[tokio::test]
async fn rejects_invalid_scopes_and_unknown_envelope_fields() {
    let manager = AuthManager::new(
        http(),
        "https://example.com",
        Credentials::AccessToken("static".into()),
        "https://api.amazon.com/auth/o2/token",
    )
    .unwrap();
    for path in [
        "",
        "orders",
        "//elsewhere/orders",
        "/orders?x",
        "/orders#x",
        "/orders\\x",
        "/orders\nx",
        "/orders%",
        "/orders%2",
        "/orders%GG",
    ] {
        assert_eq!(
            manager.token(Some(&scope(path))).await.unwrap_err(),
            AuthError::InvalidConfig,
            "{path}"
        );
    }
    let mut invalid = scope("/orders");
    invalid.resources.clear();
    assert_eq!(
        manager.token(Some(&invalid)).await.unwrap_err(),
        AuthError::InvalidConfig
    );
    invalid.resources = vec![scope("/orders").resources[0].clone(); 51];
    assert_eq!(
        manager.token(Some(&invalid)).await.unwrap_err(),
        AuthError::InvalidConfig
    );
    invalid = scope("/orders");
    invalid.resources[0].method = "PATCH".into();
    assert_eq!(
        manager.token(Some(&invalid)).await.unwrap_err(),
        AuthError::InvalidConfig
    );
    invalid = scope("/orders");
    invalid.resources[0].data_elements = vec!["".into()];
    assert_eq!(
        manager.token(Some(&invalid)).await.unwrap_err(),
        AuthError::InvalidConfig
    );
    invalid = scope("/orders");
    invalid.target_application = Some("".into());
    assert_eq!(
        manager.token(Some(&invalid)).await.unwrap_err(),
        AuthError::InvalidConfig
    );
    let parsed: RestrictedScope = serde_json::from_value(json!({"resources":[{"method":"GET","path":"/orders","data_elements":[]}],"target_application":null})).unwrap();
    assert_eq!(
        serde_json::to_value(parsed).unwrap(),
        json!({"resources":[{"method":"GET","path":"/orders","data_elements":[]}],"target_application":null})
    );
    assert!(serde_json::from_value::<RestrictedScope>(json!({"resources":[],"typo":1})).is_err());
    assert!(
        serde_json::from_value::<RestrictedResource>(
            json!({"method":"GET","path":"/orders","data_elements":[],"typo":1})
        )
        .is_err()
    );
}

#[tokio::test]
async fn invalid_lwa_responses_are_sanitized() {
    for body in [
        json!({"access_token":"body-secret","token_type":"other","expires_in":120}).to_string(),
        json!({"access_token":"body-secret","token_type":"Bearer","expires_in":0}).to_string(),
        json!({"access_token":"body-secret","token_type":"Bearer","expires_in":-1}).to_string(),
        json!({"access_token":"body-secret","token_type":"Bearer","expires_in":1.5}).to_string(),
        json!({"access_token":"body-secret","token_type":"Bearer","expires_in":"120"}).to_string(),
        json!({"access_token":"","token_type":"Bearer","expires_in":120}).to_string(),
        json!({"access_token":"body-secret\n","token_type":"Bearer","expires_in":120}).to_string(),
        json!({"access_token":"body-secret","token_type":"Bearer","expires_in":u64::MAX})
            .to_string(),
        "body-secret".into(),
        "body-secret".repeat(6554),
    ] {
        let (origin, task) = server(vec![(200, body)]).await;
        let manager =
            AuthManager::new(http(), &origin, refresh(), &format!("{origin}/auth")).unwrap();
        let error = manager.token(None).await.unwrap_err();
        assert_eq!(error, AuthError::InvalidResponse);
        assert!(!format!("{error:?} {error}").contains("secret"));
        assert!(std::error::Error::source(&error).is_none());
        task.await.unwrap();
    }
}

#[tokio::test]
async fn rejected_status_keeps_only_status() {
    let (origin, task) = server(vec![(401, "server-secret".into())]).await;
    let manager = AuthManager::new(http(), &origin, refresh(), &format!("{origin}/auth")).unwrap();
    assert_eq!(
        manager.token(None).await.unwrap_err(),
        AuthError::Rejected(401)
    );
    task.await.unwrap();
}

#[test]
fn scope_can_be_validated_without_a_manager() {
    assert_eq!(scope("/orders/{orderId}/address").validate(), Ok(()));
    assert_eq!(
        scope("//elsewhere/orders").validate(),
        Err(AuthError::InvalidConfig)
    );
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

#[tokio::test]
async fn coalesces_success_and_failure_without_retrying() {
    for (status, body, expected) in [
        (200, lwa("shared", 120), Ok("shared")),
        (
            401,
            "secret rejected body".into(),
            Err(AuthError::Rejected(401)),
        ),
    ] {
        let gate = Arc::new(Notify::new());
        let mut server = gated_server(vec![(status, body, Some(gate.clone()))]).await;
        let manager = AuthManager::new(
            http(),
            &server.origin,
            refresh(),
            &format!("{}/auth", server.origin),
        )
        .unwrap();
        let mut callers = Vec::new();
        for _ in 0..16 {
            let manager = manager.clone();
            callers.push(tokio::spawn(async move { manager.token(None).await }));
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
async fn cancelled_waiters_preserve_refresh_and_all_waiters_can_recover() {
    for cancel_all in [false, true] {
        let gate = Arc::new(Notify::new());
        let mut responses = vec![(200, lwa("recovered", 120), Some(gate.clone()))];
        if cancel_all {
            responses.push((200, lwa("recovered", 120), None));
        }
        let mut server = gated_server(responses).await;
        let manager = AuthManager::new(
            http(),
            &server.origin,
            refresh(),
            &format!("{}/auth", server.origin),
        )
        .unwrap();
        let first_manager = manager.clone();
        let first = tokio::spawn(async move { first_manager.token(None).await });
        server.requests.recv().await.unwrap();
        let next_manager = manager.clone();
        let mut next = tokio::spawn(async move { next_manager.token(None).await });
        tokio::task::yield_now().await;
        first.abort();
        let _ = first.await;
        if cancel_all {
            next.abort();
            let _ = next.await;
            let next_manager = manager.clone();
            next = tokio::spawn(async move { next_manager.token(None).await });
        }
        gate.notify_one();
        assert_eq!(next.await.unwrap().unwrap(), "recovered");
        assert_eq!(manager.token(None).await.unwrap(), "recovered");
        if cancel_all {
            server.requests.recv().await.unwrap();
        }
        assert!(server.requests.try_recv().is_err());
    }
}

#[tokio::test]
async fn unrelated_restricted_scopes_refresh_independently() {
    let gate = Arc::new(Notify::new());
    let mut server = gated_server(vec![
        (200, rdt("first", 120), Some(gate.clone())),
        (200, rdt("second", 120), None),
    ])
    .await;
    let manager = AuthManager::new(
        http(),
        &server.origin,
        Credentials::AccessToken("static".into()),
        "https://api.amazon.com/auth/o2/token",
    )
    .unwrap();
    let first_manager = manager.clone();
    let first = tokio::spawn(async move { first_manager.token(Some(&scope("/first"))).await });
    server.requests.recv().await.unwrap();
    assert_eq!(
        manager.token(Some(&scope("/second"))).await.unwrap(),
        "second"
    );
    gate.notify_one();
    assert_eq!(first.await.unwrap().unwrap(), "first");
}

#[tokio::test]
async fn short_lifetimes_refresh_early_and_expired_tokens_are_not_reused() {
    let (origin, task) = server(vec![
        (200, lwa("first", 10)),
        (200, lwa("second", 10)),
        (200, lwa("third", 10)),
    ])
    .await;
    let manager = AuthManager::new(http(), &origin, refresh(), &format!("{origin}/auth")).unwrap();
    assert_eq!(manager.token(None).await.unwrap(), "first");
    tokio::time::pause();
    tokio::time::advance(Duration::from_secs(8)).await;
    assert_eq!(manager.token(None).await.unwrap(), "first");
    tokio::time::advance(Duration::from_secs(1)).await;
    tokio::time::resume();
    assert_eq!(manager.token(None).await.unwrap(), "second");
    tokio::time::pause();
    tokio::time::advance(Duration::from_secs(11)).await;
    tokio::time::resume();
    assert_eq!(manager.token(None).await.unwrap(), "third");
    assert_eq!(task.await.unwrap().len(), 3);
}

#[tokio::test]
async fn lifetimes_begin_before_the_request_finishes() {
    let gate = Arc::new(Notify::new());
    let mut server = gated_server(vec![
        (200, lwa("already-expired", 1), Some(gate.clone())),
        (200, lwa("fresh", 120), None),
    ])
    .await;
    let manager = AuthManager::new(
        http(),
        &server.origin,
        refresh(),
        &format!("{}/auth", server.origin),
    )
    .unwrap();
    let first_manager = manager.clone();
    let first = tokio::spawn(async move { first_manager.token(None).await });
    server.requests.recv().await.unwrap();
    tokio::time::pause();
    tokio::time::advance(Duration::from_millis(1100)).await;
    tokio::time::resume();
    gate.notify_one();
    assert_eq!(
        first.await.unwrap().unwrap_err(),
        AuthError::InvalidResponse
    );
    assert_eq!(manager.token(None).await.unwrap(), "fresh");
}

#[tokio::test]
async fn resource_data_element_and_target_scopes_never_share_rdt() {
    let (origin, task) = server(
        (1..=5)
            .map(|index| (200, rdt(&format!("token-{index}"), 120)))
            .collect(),
    )
    .await;
    let manager = AuthManager::new(
        http(),
        &origin,
        Credentials::AccessToken("static".into()),
        "https://api.amazon.com/auth/o2/token",
    )
    .unwrap();
    let first = scope("/first");
    let second = scope("/second");
    let mut third = first.clone();
    third.resources[0].data_elements = vec!["buyerInfo".into()];
    let mut fourth = first.clone();
    fourth.target_application = Some("target".into());
    let mut fifth = first.clone();
    fifth.resources[0].method = "POST".into();
    for (index, scope) in [first, second, third, fourth, fifth].iter().enumerate() {
        assert_eq!(
            manager.token(Some(scope)).await.unwrap(),
            format!("token-{}", index + 1)
        );
    }
    assert_eq!(task.await.unwrap().len(), 5);
}

#[tokio::test]
async fn managers_isolate_credentials_and_origins() {
    let (first_origin, first_task) =
        server(vec![(200, rdt("first", 120)), (200, rdt("second", 120))]).await;
    let (other_origin, other_task) = server(vec![(200, rdt("other", 120))]).await;
    for (origin, credential, expected) in [
        (&first_origin, "credential-a", "first"),
        (&first_origin, "credential-b", "second"),
        (&other_origin, "credential-a", "other"),
    ] {
        let manager = AuthManager::new(
            http(),
            origin,
            Credentials::AccessToken(credential.into()),
            "https://api.amazon.com/auth/o2/token",
        )
        .unwrap();
        assert_eq!(
            manager.token(Some(&scope("/same"))).await.unwrap(),
            expected
        );
    }
    let first_requests = first_task.await.unwrap();
    assert!(first_requests[0].contains("x-amz-access-token: credential-a\r\n"));
    assert!(first_requests[1].contains("x-amz-access-token: credential-b\r\n"));
    other_task.await.unwrap();
}

#[tokio::test]
async fn restricted_cache_evicts_old_scopes_after_128_entries() {
    let (origin, task) = server(
        (0..130)
            .map(|index| (200, rdt(&format!("token-{index}"), 120)))
            .collect(),
    )
    .await;
    let manager = AuthManager::new(
        http(),
        &origin,
        Credentials::AccessToken("static".into()),
        "https://api.amazon.com/auth/o2/token",
    )
    .unwrap();
    for index in 0..129 {
        assert_eq!(
            manager
                .token(Some(&scope(&format!("/scope-{index}"))))
                .await
                .unwrap(),
            format!("token-{index}")
        );
    }
    assert_eq!(
        manager.token(Some(&scope("/scope-128"))).await.unwrap(),
        "token-128"
    );
    assert_eq!(
        manager.token(Some(&scope("/scope-0"))).await.unwrap(),
        "token-129"
    );
    assert_eq!(task.await.unwrap().len(), 130);
}

#[tokio::test]
async fn invalid_rdt_responses_are_rejected() {
    for body in [
        json!({"restrictedDataToken":"secret","expiresIn":0}),
        json!({"restrictedDataToken":"secret","expiresIn":1.5}),
        json!({"restrictedDataToken":"secret","expiresIn":"120"}),
        json!({"restrictedDataToken":"secret","expiresIn":u64::MAX}),
        json!({"restrictedDataToken":"","expiresIn":120}),
        json!({"restrictedDataToken":"secret\n","expiresIn":120}),
        json!({"restricted_data_token":"secret","expires_in":120}),
    ] {
        let (origin, task) = server(vec![(200, body.to_string())]).await;
        let manager = AuthManager::new(
            http(),
            &origin,
            Credentials::AccessToken("static".into()),
            "https://api.amazon.com/auth/o2/token",
        )
        .unwrap();
        assert_eq!(
            manager.token(Some(&scope("/orders"))).await.unwrap_err(),
            AuthError::InvalidResponse
        );
        task.await.unwrap();
    }
}

#[tokio::test]
async fn reuses_the_supplied_clients_existing_connection_pool() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let origin = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut stream, _) = listener.accept().await.unwrap();
        let mut requests = Vec::new();
        for body in ["{}".into(), lwa("pooled-lwa", 120), rdt("pooled-rdt", 120)] {
            requests.push(read_request(&mut stream).await);
            let reply = format!(
                "HTTP/1.1 200 OK\r\nContent-Length: {}\r\n\r\n{body}",
                body.len()
            );
            stream.write_all(reply.as_bytes()).await.unwrap();
        }
        requests
    });
    let supplied = http();
    supplied
        .get(format!("{origin}/warmup"))
        .send()
        .await
        .unwrap()
        .bytes()
        .await
        .unwrap();
    let manager =
        AuthManager::new(supplied, &origin, refresh(), &format!("{origin}/auth")).unwrap();
    assert_eq!(
        manager.token(Some(&scope("/orders"))).await.unwrap(),
        "pooled-rdt"
    );
    let requests = task.await.unwrap();
    assert_eq!(requests.len(), 3);
    assert!(requests[1].contains("user-agent: auth-supplied-client\r\n"));
    assert!(requests[2].contains("x-amz-access-token: pooled-lwa\r\n"));
}

#[tokio::test]
async fn response_limit_applies_to_fixed_length_and_chunked_bodies() {
    for (length, expected) in [
        (65536, Ok("limit-token")),
        (65537, Err(AuthError::InvalidResponse)),
    ] {
        let mut body = lwa("limit-token", 120);
        body.extend(std::iter::repeat_n(' ', length - body.len()));
        let (origin, task) = server(vec![(200, body)]).await;
        let manager =
            AuthManager::new(http(), &origin, refresh(), &format!("{origin}/auth")).unwrap();
        let result = manager.token(None).await;
        match expected {
            Ok(value) => assert_eq!(result.unwrap(), value),
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
    let manager = AuthManager::new(http(), &origin, refresh(), &format!("{origin}/auth")).unwrap();
    assert_eq!(
        manager.token(None).await.unwrap_err(),
        AuthError::InvalidResponse
    );
    task.await.unwrap();
}

#[tokio::test]
async fn transport_errors_and_timeouts_never_retain_urls_or_secrets() {
    let gate = Arc::new(Notify::new());
    let mut server = gated_server(vec![(200, lwa("secret", 120), Some(gate))]).await;
    let supplied = reqwest::Client::builder()
        .timeout(Duration::from_millis(20))
        .build()
        .unwrap();
    let manager = AuthManager::new(
        supplied,
        &server.origin,
        refresh(),
        &format!("{}/auth-secret", server.origin),
    )
    .unwrap();
    let error = manager.token(None).await.unwrap_err();
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
    let manager =
        AuthManager::new(http(), &origin, refresh(), &format!("{origin}/auth-secret")).unwrap();
    let error = manager.token(None).await.unwrap_err();
    assert_eq!(error, AuthError::Transport);
    assert!(!format!("{error} {error:?}").contains("secret"));
    assert!(std::error::Error::source(&error).is_none());
    task.await.unwrap();
}

#[tokio::test]
async fn restricted_refreshes_coalesce_failure_and_allow_later_recovery() {
    let gate = Arc::new(Notify::new());
    let mut server = gated_server(vec![
        (403, "body-secret".into(), Some(gate.clone())),
        (200, rdt("recovered", 120), None),
    ])
    .await;
    let manager = AuthManager::new(
        http(),
        &server.origin,
        Credentials::AccessToken("static".into()),
        "https://api.amazon.com/auth/o2/token",
    )
    .unwrap();
    let mut callers = Vec::new();
    for _ in 0..16 {
        let manager = manager.clone();
        callers.push(tokio::spawn(async move {
            manager.token(Some(&scope("/orders"))).await
        }));
    }
    server.requests.recv().await.unwrap();
    for _ in 0..32 {
        tokio::task::yield_now().await;
    }
    gate.notify_one();
    for caller in callers {
        assert_eq!(caller.await.unwrap().unwrap_err(), AuthError::Rejected(403));
    }
    assert!(server.requests.try_recv().is_err());
    assert_eq!(
        manager.token(Some(&scope("/orders"))).await.unwrap(),
        "recovered"
    );
}

#[tokio::test]
async fn long_lifetimes_refresh_60_seconds_early() {
    let (origin, task) = server(vec![(200, lwa("first", 1200)), (200, lwa("second", 1200))]).await;
    let manager = AuthManager::new(http(), &origin, refresh(), &format!("{origin}/auth")).unwrap();
    assert_eq!(manager.token(None).await.unwrap(), "first");
    tokio::time::pause();
    tokio::time::advance(Duration::from_secs(1139)).await;
    assert_eq!(manager.token(None).await.unwrap(), "first");
    tokio::time::advance(Duration::from_secs(1)).await;
    tokio::time::resume();
    assert_eq!(manager.token(None).await.unwrap(), "second");
    assert_eq!(task.await.unwrap().len(), 2);
}

#[tokio::test]
async fn eviction_preserves_active_identical_scope_refreshes() {
    let gate = Arc::new(Notify::new());
    let mut responses = vec![(200, rdt("active", 120), Some(gate.clone()))];
    responses.extend((1..=128).map(|index| (200, rdt(&format!("token-{index}"), 120), None)));
    let mut server = gated_server(responses).await;
    let manager = AuthManager::new(
        http(),
        &server.origin,
        Credentials::AccessToken("static".into()),
        "https://api.amazon.com/auth/o2/token",
    )
    .unwrap();
    let first_manager = manager.clone();
    let first = tokio::spawn(async move { first_manager.token(Some(&scope("/active"))).await });
    server.requests.recv().await.unwrap();
    for index in 1..=128 {
        assert_eq!(
            manager
                .token(Some(&scope(&format!("/scope-{index}"))))
                .await
                .unwrap(),
            format!("token-{index}")
        );
        server.requests.recv().await.unwrap();
    }
    let second_manager = manager.clone();
    let second = tokio::spawn(async move { second_manager.token(Some(&scope("/active"))).await });
    for _ in 0..32 {
        tokio::task::yield_now().await;
    }
    gate.notify_one();
    assert_eq!(first.await.unwrap().unwrap(), "active");
    assert_eq!(second.await.unwrap().unwrap(), "active");
    assert!(server.requests.try_recv().is_err());
}

#[tokio::test]
async fn full_active_cache_waits_for_capacity_and_every_completion_releases_it() {
    for completion in ["success", "failure", "cancel"] {
        let gate = Arc::new(Notify::new());
        let first_gate = Arc::new(Notify::new());
        let first_status = if completion == "failure" { 403 } else { 200 };
        let mut responses = vec![(first_status, rdt("active", 120), Some(first_gate.clone()))];
        responses.extend((1..128).map(|_| (200, rdt("active", 120), Some(gate.clone()))));
        responses.push((200, rdt("admitted", 120), None));
        let mut server = gated_server(responses).await;
        let manager = AuthManager::new(
            http(),
            &server.origin,
            Credentials::AccessToken("static".into()),
            "https://api.amazon.com/auth/o2/token",
        )
        .unwrap();
        let mut callers = Vec::new();
        for index in 0..128 {
            let manager = manager.clone();
            callers.push(tokio::spawn(async move {
                manager
                    .token(Some(&scope(&format!("/scope-{index}"))))
                    .await
            }));
            server.requests.recv().await.unwrap();
        }
        let waiting_manager = manager.clone();
        let waiting =
            tokio::spawn(async move { waiting_manager.token(Some(&scope("/new-scope"))).await });
        for _ in 0..32 {
            tokio::task::yield_now().await;
        }
        assert!(server.requests.try_recv().is_err());
        let first = callers.remove(0);
        match completion {
            "cancel" => {
                first.abort();
                let _ = first.await;
            }
            "failure" => {
                first_gate.notify_one();
                assert_eq!(first.await.unwrap().unwrap_err(), AuthError::Rejected(403));
            }
            _ => {
                first_gate.notify_one();
                assert_eq!(first.await.unwrap().unwrap(), "active");
            }
        }
        assert_eq!(waiting.await.unwrap().unwrap(), "admitted");
        assert!(server.requests.recv().await.unwrap().contains("/new-scope"));
        gate.notify_waiters();
        for caller in callers {
            assert_eq!(caller.await.unwrap().unwrap(), "active");
        }
        assert!(server.requests.try_recv().is_err());
    }
}
