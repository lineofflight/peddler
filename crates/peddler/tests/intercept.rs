mod support;

use bytes::Bytes;
use futures_util::StreamExt;
use peddler::{
    Client, ClientConfig, Error, Pool, Request, Response,
    auth::{AuthError, LwaClient, TokenSource},
    documents::{Error as DocumentError, TransferOptions, UploadOptions},
    intercept::{Exchange, Failure, Interceptor, Reply},
};
use std::{
    sync::{
        Arc, Mutex,
        atomic::{AtomicBool, AtomicUsize, Ordering},
    },
    time::Duration,
};
use support::{GZIP, http, replies};

/// What a scripted interceptor does with an exchange.
enum Step {
    Answer(u16, Vec<(&'static str, &'static str)>, Vec<u8>),
    Fail(Failure),
    Real,
}

/// The status and body of each real response.
type Seen = Vec<(u16, Vec<u8>)>;

/// Takes its steps in order, and keeps every exchange and every real response it saw.
#[derive(Clone, Default)]
struct Script {
    off: Arc<AtomicBool>,
    steps: Arc<Mutex<Vec<Step>>>,
    exchanges: Arc<Mutex<Vec<Exchange>>>,
    seen: Arc<Mutex<Seen>>,
}

impl Script {
    fn new(steps: Vec<Step>) -> Self {
        let script = Self::default();
        *script.steps.lock().unwrap() = steps;
        script
    }

    fn pool(&self) -> Pool {
        Pool::with_user_agent("Peddler/test")
            .unwrap()
            .with_interceptor(self.clone())
    }

    fn client(&self, base_url: &str, retries: u32) -> Client {
        let mut config = ClientConfig::new(base_url, "secret-token");
        config.retry.max_retries = retries;
        config.pool = Some(self.pool());
        Client::with_config(config).unwrap()
    }

    fn exchanges(&self) -> Vec<Exchange> {
        std::mem::take(&mut self.exchanges.lock().unwrap())
    }
}

impl Interceptor for Script {
    fn enabled(&self) -> bool {
        !self.off.load(Ordering::SeqCst)
    }

    fn exchange<'a>(&'a self, exchange: Exchange, real: Reply<'a>) -> Reply<'a> {
        Box::pin(async move {
            self.exchanges.lock().unwrap().push(exchange);
            let step = self.steps.lock().unwrap().remove(0);
            match step {
                Step::Answer(status, headers, body) => Ok(Response {
                    status,
                    headers: headers
                        .into_iter()
                        .map(|(name, value)| (name.to_owned(), value.to_owned()))
                        .collect(),
                    body,
                }),
                Step::Fail(failure) => Err(failure),
                Step::Real => {
                    let response = real.await?;
                    self.seen
                        .lock()
                        .unwrap()
                        .push((response.status, response.body.clone()));
                    Ok(response)
                }
            }
        })
    }
}

fn header<'a>(exchange: &'a Exchange, name: &str) -> Vec<&'a str> {
    exchange
        .headers
        .iter()
        .filter(|(key, _)| key == name)
        .map(|(_, value)| value.as_str())
        .collect()
}

fn post(body: &str) -> Request {
    Request {
        method: "POST".into(),
        path: "/things/a%20b".into(),
        query: vec![("ids".into(), "1,2".into()), ("q".into(), "a b".into())],
        headers: vec![],
        body: Some(body.as_bytes().to_vec()),
    }
}

fn get() -> Request {
    Request {
        method: "GET".into(),
        path: "/".into(),
        query: vec![],
        headers: vec![],
        body: None,
    }
}

// No address answers these: an answered exchange opens no connection.
const NOWHERE: &str = "https://sellingpartnerapi-eu.amazon.com";

#[tokio::test]
async fn an_exchange_is_the_request_as_it_is_sent_and_the_answer_is_the_response() {
    let script = Script::new(vec![Step::Answer(
        201,
        vec![
            ("x-amzn-requestid", "r1"),
            ("x-repeat", "a"),
            ("x-repeat", "b"),
        ],
        b"{\"ok\":true}".to_vec(),
    )]);
    let response = script
        .client(NOWHERE, 0)
        .execute(post("{\"a\":1}"))
        .await
        .unwrap();
    assert_eq!(response.status, 201);
    assert_eq!(response.body, b"{\"ok\":true}");
    assert_eq!(response.headers.len(), 3);

    let exchanges = script.exchanges();
    let exchange = &exchanges[0];
    assert_eq!(exchange.method, "POST");
    assert_eq!(
        exchange.url,
        "https://sellingpartnerapi-eu.amazon.com/things/a%20b?ids=1%2C2&q=a+b"
    );
    assert_eq!(exchange.body, b"{\"a\":1}");
    assert_eq!(header(exchange, "x-amz-access-token"), ["secret-token"]);
    assert_eq!(header(exchange, "content-type"), ["application/json"]);
    assert_eq!(header(exchange, "user-agent"), ["Peddler/test"]);
    assert_eq!(header(exchange, "accept"), ["*/*"]);
    assert_eq!(header(exchange, "x-amz-date").len(), 1);
    // Nothing of the request shows when an exchange is printed.
    assert_eq!(format!("{exchange:?}"), "Exchange { method: \"POST\", .. }");
}

#[tokio::test]
async fn a_real_exchange_sends_the_headers_it_names_and_the_interceptor_sees_the_response() {
    let server = replies(vec![http(200, "X-Real: yes\r\n", b"real")]).await;
    let script = Script::new(vec![Step::Real]);
    let response = script
        .client(&server.url, 0)
        .execute(post("{}"))
        .await
        .unwrap();
    assert_eq!(
        (response.status, response.body.as_slice()),
        (200, &b"real"[..])
    );
    assert_eq!(*script.seen.lock().unwrap(), [(200, b"real".to_vec())]);

    // The server got every header of the exchange, and only `host` and
    // `content-length` beside them.
    let request = server.requests().remove(0);
    let head = request.split("\r\n\r\n").next().unwrap().to_owned();
    let mut received: Vec<(String, String)> = head
        .lines()
        .skip(1)
        .map(|line| {
            let (name, value) = line.split_once(": ").unwrap();
            (name.to_ascii_lowercase(), value.to_owned())
        })
        .filter(|(name, _)| name != "host" && name != "content-length")
        .collect();
    let mut named = script.exchanges().remove(0).headers;
    received.sort();
    named.sort();
    assert_eq!(received, named);
}

#[tokio::test]
async fn an_interceptor_that_is_off_is_not_asked() {
    let server = replies(vec![http(200, "", b"real")]).await;
    let script = Script::new(vec![]);
    script.off.store(true, Ordering::SeqCst);
    let response = script.client(&server.url, 0).execute(get()).await.unwrap();
    assert_eq!(response.body, b"real");
    assert!(script.exchanges().is_empty());
}

#[tokio::test]
async fn a_failure_is_the_error_of_each_client_and_is_retried_as_one() {
    for (failure, error) in [
        (Failure::Timeout, Error::Timeout),
        (Failure::Transport, Error::Transport),
    ] {
        // A write that got no response is not sent again.
        let script = Script::new(vec![Step::Fail(failure)]);
        let result = script.client(NOWHERE, 3).execute(post("{}")).await;
        assert_eq!(result.unwrap_err(), error);
        assert_eq!(script.exchanges().len(), 1);
    }
    // A GET is, and so is anything after a 429.
    let script = Script::new(vec![
        Step::Fail(Failure::Timeout),
        Step::Answer(429, vec![("retry-after", "0")], vec![]),
        Step::Answer(200, vec![], vec![]),
    ]);
    let response = script.client(NOWHERE, 2).execute(get()).await.unwrap();
    assert_eq!(response.status, 200);
    assert_eq!(script.exchanges().len(), 3);

    for (failure, error) in [
        (Failure::Timeout, AuthError::Timeout),
        (Failure::Transport, AuthError::Transport),
    ] {
        let script = Script::new(vec![Step::Fail(failure)]);
        let lwa = lwa(&script);
        assert_eq!(lwa.refresh("refresh").await.unwrap_err(), error);
    }
    for (failure, error) in [
        (Failure::Timeout, DocumentError::Timeout),
        (Failure::Transport, DocumentError::Transport),
    ] {
        let script = Script::new(vec![Step::Fail(failure), Step::Fail(failure)]);
        let documents = script.client(NOWHERE, 0).documents();
        let download = documents
            .download("https://signed.example/d", TransferOptions::default())
            .await;
        assert_eq!(download.unwrap_err(), error);
        let source = futures_util::stream::iter([Ok::<_, ()>(Bytes::from_static(b"x"))]);
        let upload = documents
            .upload("https://signed.example/u", source, UploadOptions::default())
            .await;
        assert_eq!(upload.unwrap_err(), error);
    }
}

#[tokio::test]
async fn a_token_source_is_asked_before_every_exchange_of_a_call() {
    let script = Script::new(vec![
        Step::Answer(429, vec![("retry-after", "0")], vec![]),
        Step::Answer(200, vec![], vec![]),
    ]);
    let asked = Arc::new(AtomicUsize::new(0));
    let counter = asked.clone();
    let source = TokenSource::new(move || {
        let number = counter.fetch_add(1, Ordering::SeqCst) + 1;
        async move { Ok(format!("token-{number}")) }
    });
    let mut config = ClientConfig::new(NOWHERE, source);
    config.retry.max_retries = 1;
    config.pool = Some(script.pool());
    let client = Client::with_config(config).unwrap();
    assert_eq!(client.execute(get()).await.unwrap().status, 200);
    let tokens: Vec<String> = script
        .exchanges()
        .iter()
        .map(|exchange| header(exchange, "x-amz-access-token")[0].to_owned())
        .collect();
    assert_eq!(tokens, ["token-1", "token-2"]);
}

fn lwa(script: &Script) -> LwaClient {
    LwaClient::with_pool(
        &script.pool(),
        "id",
        "client-secret",
        "https://api.amazon.com/auth/o2/token",
        Duration::from_secs(5),
    )
    .unwrap()
}

#[tokio::test]
async fn a_grant_is_an_exchange_of_its_form_and_reads_the_answer_as_a_reply() {
    let tokens = br#"{"access_token":"granted","token_type":"bearer","expires_in":3600}"#;
    let script = Script::new(vec![
        Step::Answer(200, vec![], tokens.to_vec()),
        Step::Answer(400, vec![], br#"{"error":"invalid_grant"}"#.to_vec()),
        Step::Answer(200, vec![], vec![b' '; 64 * 1024 + 1]),
    ]);
    let lwa = lwa(&script);
    assert_eq!(lwa.refresh("r+1").await.unwrap().access_token, "granted");
    let rejected = lwa.refresh("r").await.unwrap_err();
    assert_eq!(
        rejected,
        AuthError::Rejected {
            status: 400,
            code: Some("invalid_grant".into())
        }
    );
    // A reply is no larger than one from the network may be.
    let oversized = lwa.refresh("r").await.unwrap_err();
    assert_eq!(oversized, AuthError::InvalidResponse);

    let exchanges = script.exchanges();
    let exchange = &exchanges[0];
    assert_eq!(exchange.method, "POST");
    assert_eq!(exchange.url, "https://api.amazon.com/auth/o2/token");
    assert_eq!(
        header(exchange, "content-type"),
        ["application/x-www-form-urlencoded"]
    );
    assert_eq!(
        String::from_utf8_lossy(&exchange.body),
        "grant_type=refresh_token&client_id=id&client_secret=client-secret&refresh_token=r%2B1"
    );
    assert!(header(exchange, "x-amz-access-token").is_empty());
}

#[tokio::test]
async fn a_download_reads_the_answer_as_a_document_and_a_rejection_keeps_the_reply() {
    let script = Script::new(vec![
        Step::Answer(
            200,
            vec![
                ("content-encoding", "gzip"),
                ("content-type", "text/plain; charset=utf-8"),
            ],
            GZIP.to_vec(),
        ),
        Step::Answer(403, vec![("x-amz-request-id", "s3")], vec![b'x'; 70_000]),
        Step::Answer(200, vec![], b"12345".to_vec()),
    ]);
    let documents = script.client(NOWHERE, 0).documents();
    let url = "https://signed.example/report?X-Amz-Signature=abc";
    let download = documents
        .download(url, TransferOptions::default())
        .await
        .unwrap();
    assert_eq!(download.status(), 200);
    assert_eq!(download.charset().as_deref(), Some("utf-8"));
    let chunks: Vec<_> = download.into_chunks().collect().await;
    assert_eq!(chunks, [Ok(Bytes::from_static(b"{\"x\":1}\n"))]);

    let Err(DocumentError::Rejected(rejection)) =
        documents.download(url, TransferOptions::default()).await
    else {
        panic!("a reply outside 2xx is a rejection");
    };
    assert_eq!(rejection.status, 403);
    assert_eq!(rejection.headers["x-amz-request-id"], "s3");
    assert_eq!(rejection.body.len(), 64 << 10);

    // The limit of a document holds for an answer too.
    let options = TransferOptions {
        max_bytes: 4,
        ..TransferOptions::default()
    };
    let limited = documents.download(url, options).await.unwrap();
    let chunks: Vec<_> = limited.into_chunks().collect().await;
    assert_eq!(chunks, [Err(DocumentError::ByteLimit)]);

    let exchanges = script.exchanges();
    assert_eq!(
        (exchanges[0].method.as_str(), exchanges[0].url.as_str()),
        ("GET", url)
    );
    assert!(exchanges[0].body.is_empty());
    assert!(header(&exchanges[0], "x-amz-access-token").is_empty());
}

#[tokio::test]
async fn an_upload_is_read_whole_under_its_checks_before_it_is_an_exchange() {
    let script = Script::new(vec![
        Step::Answer(200, vec![("etag", "e1")], b"stored".to_vec()),
        Step::Answer(403, vec![], b"denied".to_vec()),
    ]);
    let documents = script.client(NOWHERE, 0).documents();
    let url = "https://signed.example/feed?X-Amz-Signature=abc";
    let source = || {
        futures_util::stream::iter([
            Ok::<_, ()>(Bytes::from_static(b"ab")),
            Ok(Bytes::from_static(b"cd")),
        ])
    };
    let options = |length| UploadOptions {
        content_type: "text/xml; charset=UTF-8".into(),
        headers: vec![("x-amz-meta-a".into(), "1".into())],
        content_length: length,
        ..UploadOptions::default()
    };
    let response = documents
        .upload(url, source(), options(Some(4)))
        .await
        .unwrap();
    assert_eq!(
        (response.status, response.body.as_slice()),
        (200, &b"stored"[..])
    );
    assert_eq!(response.headers["etag"], "e1");
    let rejected = documents.upload(url, source(), options(None)).await;
    assert!(matches!(rejected, Err(DocumentError::Rejected(rejection)) if rejection.status == 403));
    // A source of another length than the one declared, or one that fails, is never
    // handed over.
    let mismatch = documents.upload(url, source(), options(Some(5))).await;
    assert_eq!(mismatch.unwrap_err(), DocumentError::LengthMismatch);
    let failing = futures_util::stream::iter([Ok(Bytes::from_static(b"ab")), Err(())]);
    let failed = documents.upload(url, failing, options(None)).await;
    assert_eq!(failed.unwrap_err(), DocumentError::UploadSource);

    let exchanges = script.exchanges();
    assert_eq!(exchanges.len(), 2);
    let exchange = &exchanges[0];
    assert_eq!(
        (exchange.method.as_str(), exchange.url.as_str()),
        ("PUT", url)
    );
    assert_eq!(exchange.body, b"abcd");
    assert_eq!(
        header(exchange, "content-type"),
        ["text/xml; charset=UTF-8"]
    );
    assert_eq!(header(exchange, "x-amz-meta-a"), ["1"]);
    assert_eq!(header(exchange, "content-length"), ["4"]);
    assert!(header(&exchanges[1], "content-length").is_empty());
}
