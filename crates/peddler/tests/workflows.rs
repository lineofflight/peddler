use bytes::Bytes;
use futures_util::{StreamExt, TryStreamExt, stream};
use peddler::{
    Client,
    documents::{Compression, Error as DocumentError, TransferOptions, UploadOptions},
    workflows::{WaitOptions, WorkflowError},
};
use std::{
    sync::{
        Arc, Mutex,
        atomic::{AtomicBool, AtomicUsize, Ordering},
    },
    time::{Duration, Instant},
};
use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::TcpListener,
};

const GZIP: [u8; 28] = [
    31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49, 80,
    8, 0, 0, 0,
];

struct Reply {
    bytes: Vec<u8>,
    delay: Duration,
    hold: Duration,
}
fn http(status: u16, headers: &str, body: &[u8]) -> Reply {
    let mut bytes = format!(
        "HTTP/1.1 {status} Test\r\nContent-Length: {}\r\nConnection: close\r\n{headers}\r\n",
        body.len()
    )
    .into_bytes();
    bytes.extend_from_slice(body);
    Reply {
        bytes,
        delay: Duration::ZERO,
        hold: Duration::ZERO,
    }
}
fn json(status: u16, body: &str) -> Reply {
    http(
        status,
        "Content-Type: application/json\r\n",
        body.as_bytes(),
    )
}
impl Reply {
    fn delayed(mut self, delay: Duration) -> Self {
        self.delay = delay;
        self
    }
}

struct Server {
    url: String,
    requests: Arc<Mutex<Vec<String>>>,
}
impl Server {
    fn requests(&self) -> Vec<String> {
        self.requests.lock().unwrap().clone()
    }
    fn count(&self, prefix: &str) -> usize {
        self.requests()
            .iter()
            .filter(|request| request.starts_with(prefix))
            .count()
    }
}
/// Handler receives the index of the connection, the raw request text and the base URL.
async fn serve(handler: impl Fn(usize, &str, &str) -> Reply + Send + Sync + 'static) -> Server {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let url = format!("http://{}", listener.local_addr().unwrap());
    let requests = Arc::new(Mutex::new(Vec::new()));
    let log = requests.clone();
    let base = url.clone();
    let handler = Arc::new(handler);
    tokio::spawn(async move {
        let mut index = 0;
        while let Ok((mut socket, _)) = listener.accept().await {
            let (log, base, handler) = (log.clone(), base.clone(), handler.clone());
            let current = index;
            index += 1;
            tokio::spawn(async move {
                let mut bytes = Vec::new();
                let end = loop {
                    let mut buffer = [0; 4096];
                    let count = socket.read(&mut buffer).await.unwrap_or(0);
                    if count == 0 {
                        return;
                    }
                    bytes.extend_from_slice(&buffer[..count]);
                    if let Some(end) = bytes.windows(4).position(|w| w == b"\r\n\r\n") {
                        break end + 4;
                    }
                };
                let head = String::from_utf8_lossy(&bytes[..end]).to_ascii_lowercase();
                let length = head
                    .lines()
                    .find_map(|line| line.strip_prefix("content-length: ")?.parse::<usize>().ok());
                let chunked = head.contains("transfer-encoding: chunked");
                loop {
                    let body = &bytes[end..];
                    if length.is_some_and(|length| body.len() >= length)
                        || chunked && body.ends_with(b"0\r\n\r\n")
                        || length.is_none() && !chunked
                    {
                        break;
                    }
                    let mut buffer = [0; 4096];
                    let count = socket.read(&mut buffer).await.unwrap_or(0);
                    if count == 0 {
                        break;
                    }
                    bytes.extend_from_slice(&buffer[..count]);
                }
                let request = String::from_utf8_lossy(&bytes).into_owned();
                log.lock().unwrap().push(request.clone());
                let reply = handler(current, &request, &base);
                tokio::time::sleep(reply.delay).await;
                let _ = socket.write_all(&reply.bytes).await;
                tokio::time::sleep(reply.hold).await;
            });
        }
    });
    Server { url, requests }
}
fn client(url: &str) -> Client {
    Client::new(url, "SECRET_API_TOKEN").unwrap()
}
fn report_document(base: &str, algorithm: Option<&str>) -> String {
    let algorithm = algorithm
        .map(|a| format!(",\"compressionAlgorithm\":\"{a}\""))
        .unwrap_or_default();
    format!(
        "{{\"reportDocumentId\":\"d1\",\"url\":\"{base}/signed?sig=SIGNED_SECRET\"{algorithm}}}"
    )
}
async fn bytes(download: peddler::documents::Download) -> Vec<u8> {
    download
        .into_chunks()
        .try_collect::<Vec<_>>()
        .await
        .unwrap()
        .concat()
}
fn fast(interval: u64, timeout: u64) -> WaitOptions {
    WaitOptions {
        interval: Duration::from_millis(interval),
        timeout: Duration::from_millis(timeout),
    }
}

#[tokio::test]
async fn report_download_authenticates_metadata_but_never_the_signed_url() {
    let server = serve(|_, request, base| {
        if request.starts_with("GET /signed") {
            http(200, "", b"report body")
        } else {
            json(200, &report_document(base, None))
        }
    })
    .await;
    let download = client(&server.url)
        .workflows()
        .download_report_document("a/b c", TransferOptions::default())
        .await
        .unwrap();
    assert_eq!(bytes(download).await, b"report body");
    let requests = server.requests();
    assert!(
        requests[0].starts_with("GET /reports/2021-06-30/documents/a%2Fb%20c "),
        "{}",
        requests[0]
    );
    assert!(
        requests[0]
            .to_lowercase()
            .contains("x-amz-access-token: secret_api_token")
    );
    assert!(requests[1].starts_with("GET /signed?sig=SIGNED_SECRET "));
    assert!(!requests[1].to_lowercase().contains("x-amz-access-token"));
    assert!(!requests[1].contains("SECRET_API_TOKEN"));
}

#[tokio::test]
async fn gzip_metadata_decodes_with_and_without_the_header_exactly_once() {
    for header in ["", "Content-Encoding: gzip\r\n"] {
        let server = serve(move |_, request, base| {
            if request.starts_with("GET /signed") {
                http(200, header, &GZIP)
            } else {
                json(200, &report_document(base, Some("GZIP")))
            }
        })
        .await;
        let download = client(&server.url)
            .workflows()
            .download_report_document("d1", TransferOptions::default())
            .await
            .unwrap();
        let rows = download.into_jsonl().try_collect::<Vec<_>>().await.unwrap();
        assert_eq!(rows, vec![serde_json::json!({"x": 1})], "header {header:?}");
    }
}

#[tokio::test]
async fn feed_documents_use_their_own_operation_and_compression_header() {
    let server = serve(|_, request, base| {
        if request.starts_with("GET /signed") {
            http(200, "Content-Encoding: gzip\r\n", &GZIP)
        } else {
            json(
                200,
                &format!("{{\"feedDocumentId\":\"f1\",\"url\":\"{base}/signed\"}}"),
            )
        }
    })
    .await;
    let download = client(&server.url)
        .workflows()
        .download_feed_document("f1", TransferOptions::default())
        .await
        .unwrap();
    assert_eq!(bytes(download).await, b"{\"x\":1}\n");
    assert!(server.requests()[0].starts_with("GET /feeds/2021-06-30/documents/f1 "));
}

#[tokio::test]
async fn unknown_or_conflicting_compression_and_bad_metadata_never_download() {
    let cases: Vec<(&str, Option<&str>, Compression, bool)> = vec![
        ("unknown", Some("BROTLI"), Compression::Auto, false),
        ("conflict", Some("GZIP"), Compression::None, false),
        ("absent-gzip", None, Compression::Gzip, false),
        ("empty-url", None, Compression::Auto, true),
    ];
    for (name, algorithm, compression, empty_url) in cases {
        let server = serve(move |_, request, base| {
            assert!(!request.starts_with("GET /signed"), "downloaded");
            if empty_url {
                json(200, "{\"reportDocumentId\":\"d1\",\"url\":\"\"}")
            } else {
                json(200, &report_document(base, algorithm))
            }
        })
        .await;
        let error = client(&server.url)
            .workflows()
            .download_report_document(
                "d1",
                TransferOptions {
                    compression,
                    ..Default::default()
                },
            )
            .await
            .unwrap_err();
        let expected = match name {
            "unknown" => matches!(error, WorkflowError::UnsupportedCompression),
            "empty-url" => matches!(error, WorkflowError::Metadata),
            _ => matches!(error, WorkflowError::CompressionConflict),
        };
        assert!(expected, "{name}: {error:?}");
        assert_eq!(server.count("GET /signed"), 0, "{name}");
        let text = format!("{error} {error:?}");
        assert!(!text.contains("SIGNED_SECRET") && !text.contains(&server.url));
    }
}

#[tokio::test]
async fn malformed_metadata_json_and_http_errors_do_not_download() {
    let server = serve(|_, _, _| json(200, "{\"url\": 3}")).await;
    let error = client(&server.url)
        .workflows()
        .download_report_document("d1", TransferOptions::default())
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::Metadata), "{error:?}");

    let server = serve(|_, _, _| {
        json(
            404,
            "{\"errors\":[{\"code\":\"NotFound\",\"message\":\"BODY_SECRET\"}]}",
        )
    })
    .await;
    let error = client(&server.url)
        .workflows()
        .download_feed_document("d1", TransferOptions::default())
        .await
        .unwrap_err();
    let response = error.response().expect("raw response retained");
    assert_eq!(response.status, 404);
    assert!(String::from_utf8_lossy(&response.body).contains("BODY_SECRET"));
    let text = format!("{error} {error:?}");
    assert!(
        !text.contains("BODY_SECRET") && !text.contains("SECRET_API_TOKEN"),
        "{text}"
    );
    assert_eq!(server.requests().len(), 1);
}

#[tokio::test]
async fn invalid_transfer_options_fail_before_any_request() {
    let server = serve(|_, _, _| json(500, "{}")).await;
    let error = client(&server.url)
        .workflows()
        .download_report_document(
            "d1",
            TransferOptions {
                max_bytes: 0,
                ..Default::default()
            },
        )
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::InvalidConfig));
    let error = client(&server.url)
        .workflows()
        .download_report_document("", TransferOptions::default())
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::InvalidConfig));
    assert!(server.requests().is_empty());
}

#[tokio::test]
async fn transfer_non_success_and_limits_keep_download_semantics() {
    let server = serve(|_, request, base| {
        if request.starts_with("GET /signed") {
            http(403, "", b"signed denial")
        } else {
            json(200, &report_document(base, None))
        }
    })
    .await;
    let download = client(&server.url)
        .workflows()
        .download_report_document(
            "d1",
            TransferOptions {
                max_response_bytes: 6,
                ..Default::default()
            },
        )
        .await
        .unwrap();
    assert_eq!(download.status(), 403);
    assert_eq!(download.error_body(), Some(&b"signed"[..]));
    assert!(download.error_body_truncated());
}

#[tokio::test]
async fn data_kiosk_streams_jsonl_with_header_only_encoding() {
    let server = serve(|_, request, base| {
        if request.starts_with("GET /signed") {
            http(200, "Content-Encoding: gzip\r\n", &GZIP)
        } else {
            json(
                200,
                &format!("{{\"documentId\":\"k1\",\"documentUrl\":\"{base}/signed\"}}"),
            )
        }
    })
    .await;
    let rows = client(&server.url)
        .workflows()
        .download_query_document("k/1", TransferOptions::default())
        .await
        .unwrap()
        .into_jsonl()
        .try_collect::<Vec<_>>()
        .await
        .unwrap();
    assert_eq!(rows, vec![serde_json::json!({"x": 1})]);
    assert!(server.requests()[0].starts_with("GET /dataKiosk/2023-11-15/documents/k%2F1 "));

    let server = serve(|_, _, base| {
        json(
            200,
            &format!("{{\"documentId\":\"k1\",\"documentUrl\":\"{base}/signed\"}}"),
        )
    })
    .await;
    let error = client(&server.url)
        .workflows()
        .download_query_document(
            "k1",
            TransferOptions {
                compression: Compression::Gzip,
                ..Default::default()
            },
        )
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::CompressionConflict));
    assert!(
        server.requests().is_empty(),
        "conflict known without metadata"
    );
}

#[tokio::test]
async fn one_deadline_covers_metadata_and_transfer() {
    let server = serve(|_, request, base| {
        if request.starts_with("GET /signed") {
            let mut reply = http(200, "", b"");
            reply.bytes = b"HTTP/1.1 200 OK\r\nContent-Length: 100\r\n\r\npartial".to_vec();
            reply.hold = Duration::from_secs(3);
            reply
        } else {
            json(200, &report_document(base, None)).delayed(Duration::from_millis(300))
        }
    })
    .await;
    let started = Instant::now();
    let options = TransferOptions {
        timeout: Duration::from_millis(600),
        ..Default::default()
    };
    let download = client(&server.url)
        .workflows()
        .download_report_document("d1", options)
        .await
        .unwrap();
    let error = download
        .into_chunks()
        .try_collect::<Vec<_>>()
        .await
        .unwrap_err();
    assert_eq!(error, DocumentError::Timeout);
    let elapsed = started.elapsed();
    assert!(elapsed >= Duration::from_millis(550), "{elapsed:?}");
    assert!(elapsed < Duration::from_millis(900), "{elapsed:?}");

    let error = client(&server.url)
        .workflows()
        .download_report_document(
            "d1",
            TransferOptions {
                timeout: Duration::from_millis(100),
                ..Default::default()
            },
        )
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::Timeout), "{error:?}");
}

fn report(status: &str) -> String {
    format!(
        "{{\"reportId\":\"r1\",\"reportType\":\"T\",\"processingStatus\":\"{status}\",\"createdTime\":\"2024-01-01T00:00:00Z\",\"reportDocumentId\":\"d9\"}}"
    )
}

#[tokio::test]
async fn wait_for_report_polls_until_done_with_immediate_first_poll() {
    let server = serve(|index, _, _| {
        json(
            200,
            &report(["IN_QUEUE", "IN_PROGRESS", "DONE"][index.min(2)]),
        )
    })
    .await;
    let started = Instant::now();
    let response = client(&server.url)
        .workflows()
        .wait_for_report("r/1", fast(50, 5_000))
        .await
        .unwrap();
    let report = response.json().unwrap();
    assert_eq!(report.processing_status, "DONE");
    assert_eq!(report.report_document_id.as_deref(), Some("d9"));
    assert_eq!(server.requests().len(), 3);
    assert!(server.requests()[0].starts_with("GET /reports/2021-06-30/reports/r%2F1 "));
    let elapsed = started.elapsed();
    assert!(elapsed >= Duration::from_millis(100), "{elapsed:?}");
    assert!(elapsed < Duration::from_millis(1_000), "{elapsed:?}");
}

#[tokio::test]
async fn wait_returns_fatal_and_cancelled_with_ids_available() {
    for status in ["FATAL", "CANCELLED"] {
        let server = serve(move |_, _, _| json(200, &report(status))).await;
        let response = client(&server.url)
            .workflows()
            .wait_for_report("r1", fast(10, 1_000))
            .await
            .unwrap();
        let report = response.json().unwrap();
        assert_eq!(report.processing_status, status);
        assert_eq!(report.report_document_id.as_deref(), Some("d9"));
        assert_eq!(response.raw.status, 200);
    }
    let server = serve(|_, _, _| {
        json(
            200,
            "{\"feedId\":\"f1\",\"feedType\":\"T\",\"processingStatus\":\"FATAL\",\"createdTime\":\"2024-01-01T00:00:00Z\",\"resultFeedDocumentId\":\"rf\"}",
        )
    })
    .await;
    let response = client(&server.url)
        .workflows()
        .wait_for_feed("f1", fast(10, 1_000))
        .await
        .unwrap();
    assert_eq!(
        response.json().unwrap().result_feed_document_id.as_deref(),
        Some("rf")
    );
    let server = serve(|_, _, _| {
        json(
            200,
            "{\"queryId\":\"q1\",\"query\":\"x\",\"processingStatus\":\"DONE\",\"createdTime\":\"2024-01-01T00:00:00Z\",\"dataDocumentId\":\"dd\",\"errorDocumentId\":\"ed\"}",
        )
    })
    .await;
    let response = client(&server.url)
        .workflows()
        .wait_for_query("q1", fast(10, 1_000))
        .await
        .unwrap();
    let query = response.json().unwrap();
    assert_eq!(query.data_document_id.as_deref(), Some("dd"));
    assert_eq!(query.error_document_id.as_deref(), Some("ed"));
    assert!(server.requests()[0].starts_with("GET /dataKiosk/2023-11-15/queries/q1 "));
}

#[tokio::test]
async fn wait_rejects_unknown_status_and_stops_on_http_errors() {
    let server = serve(|_, _, _| json(200, &report("SOMETHING_NEW"))).await;
    let error = client(&server.url)
        .workflows()
        .wait_for_report("r1", fast(10, 1_000))
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::Status), "{error:?}");
    assert!(!format!("{error} {error:?}").contains("SOMETHING_NEW"));
    assert_eq!(server.requests().len(), 1);

    let server = serve(|_, _, _| json(429, "{\"errors\":[]}")).await;
    let error = client(&server.url)
        .workflows()
        .wait_for_report("r1", fast(10, 1_000))
        .await
        .unwrap_err();
    assert_eq!(error.response().unwrap().status, 429);
    assert_eq!(server.requests().len(), 1);

    let server = serve(|_, _, _| json(200, "{\"processingStatus\":1}")).await;
    let error = client(&server.url)
        .workflows()
        .wait_for_report("r1", fast(10, 1_000))
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::Metadata), "{error:?}");
}

#[tokio::test]
async fn wait_is_bounded_and_polls_stop_at_the_deadline() {
    let server = serve(|_, _, _| json(200, &report("IN_QUEUE"))).await;
    let started = Instant::now();
    let error = client(&server.url)
        .workflows()
        .wait_for_report("r1", fast(40, 250))
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::Timeout), "{error:?}");
    let elapsed = started.elapsed();
    assert!(elapsed >= Duration::from_millis(240), "{elapsed:?}");
    assert!(elapsed < Duration::from_millis(600), "{elapsed:?}");
    let polls = server.requests().len();
    assert!((5..=7).contains(&polls), "{polls}");
    tokio::time::sleep(Duration::from_millis(200)).await;
    assert_eq!(
        server.requests().len(),
        polls,
        "no polls after the deadline"
    );

    // A single slow poll cannot outlive the total timeout.
    let slow =
        serve(|_, _, _| json(200, &report("IN_QUEUE")).delayed(Duration::from_secs(2))).await;
    let started = Instant::now();
    let error = client(&slow.url)
        .workflows()
        .wait_for_report("r1", fast(10, 200))
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::Timeout));
    assert!(started.elapsed() < Duration::from_millis(600));
}

#[tokio::test]
async fn dropping_a_wait_stops_polling() {
    let server = serve(|_, _, _| json(200, &report("IN_PROGRESS"))).await;
    let workflows = client(&server.url).workflows();
    let task = tokio::spawn(async move {
        let _ = workflows.wait_for_report("r1", fast(20, 10_000)).await;
    });
    tokio::time::sleep(Duration::from_millis(100)).await;
    task.abort();
    let _ = task.await;
    let polls = server.requests().len();
    tokio::time::sleep(Duration::from_millis(150)).await;
    assert_eq!(server.requests().len(), polls);
}

#[tokio::test]
async fn wait_options_must_be_positive() {
    let server = serve(|_, _, _| json(200, &report("DONE"))).await;
    for options in [fast(0, 100), fast(10, 0)] {
        let error = client(&server.url)
            .workflows()
            .wait_for_report("r1", options)
            .await
            .unwrap_err();
        assert!(matches!(error, WorkflowError::InvalidConfig));
    }
    let error = client(&server.url)
        .workflows()
        .wait_for_report("", WaitOptions::default())
        .await
        .unwrap_err();
    assert!(matches!(error, WorkflowError::InvalidConfig));
    assert!(server.requests().is_empty());
    let defaults = WaitOptions::default();
    assert_eq!(defaults.interval, Duration::from_secs(5));
    assert_eq!(defaults.timeout, Duration::from_secs(300));
}

fn chunks(
    parts: &[&'static [u8]],
) -> impl futures_util::Stream<Item = Result<Bytes, ()>> + Send + 'static {
    stream::iter(
        parts
            .iter()
            .map(|part| Ok(Bytes::from_static(part)))
            .collect::<Vec<_>>(),
    )
}

#[tokio::test]
async fn feed_document_is_created_then_uploaded_with_the_exact_type_and_bytes() {
    let server = serve(|_, request, base| {
        if request.starts_with("PUT /signed") {
            http(200, "", b"")
        } else {
            json(
                201,
                &format!(
                    "{{\"feedDocumentId\":\"fd/1\",\"url\":\"{base}/signed?sig=SIGNED_SECRET\"}}"
                ),
            )
        }
    })
    .await;
    let uploaded = client(&server.url)
        .workflows()
        .create_and_upload_feed_document(
            "text/tab-separated-values; charset=UTF-8",
            chunks(&[b"a\tb\n", b"c\td\n"]),
            UploadOptions::default(),
        )
        .await
        .unwrap();
    assert_eq!(uploaded.document_id, "fd/1");
    assert_eq!(uploaded.response.status, 200);
    let requests = server.requests();
    assert_eq!(requests.len(), 2);
    let lower = requests[0].to_lowercase();
    assert!(requests[0].starts_with("POST /feeds/2021-06-30/documents "));
    assert!(lower.contains("x-amz-access-token: secret_api_token"));
    assert!(
        requests[0].ends_with("{\"contentType\":\"text/tab-separated-values; charset=UTF-8\"}")
    );
    assert!(requests[1].starts_with("PUT /signed?sig=SIGNED_SECRET "));
    let lower = requests[1].to_lowercase();
    assert!(lower.contains("content-type: text/tab-separated-values; charset=utf-8"));
    assert!(!lower.contains("x-amz-access-token"));
    assert!(requests[1].contains("a\tb\n"));
    assert!(requests[1].contains("c\td\n"));
    assert_eq!(
        server.count("POST /feeds/2021-06-30/feeds"),
        0,
        "no createFeed"
    );
}

#[tokio::test]
async fn invalid_metadata_never_reads_the_source() {
    for reply in [
        json(201, "{\"feedDocumentId\":\"fd1\",\"url\":\"\"}"),
        json(201, "{\"feedDocumentId\":\"fd1\",\"url\":\"ftp://x/y\"}"),
        json(201, "not json"),
        json(
            400,
            "{\"errors\":[{\"code\":\"InvalidInput\",\"message\":\"BODY_SECRET\"}]}",
        ),
        json(
            200,
            "{\"feedDocumentId\":\"fd1\",\"url\":\"http://127.0.0.1:1/x\"}",
        ),
    ] {
        let reply = Arc::new(Mutex::new(Some(reply)));
        let server = serve(move |_, _, _| reply.lock().unwrap().take().unwrap()).await;
        let touched = Arc::new(AtomicBool::new(false));
        let flag = touched.clone();
        let source = stream::once(async move {
            flag.store(true, Ordering::SeqCst);
            Ok::<_, ()>(Bytes::from_static(b"x"))
        });
        let error = client(&server.url)
            .workflows()
            .create_and_upload_feed_document("text/xml", source, UploadOptions::default())
            .await
            .unwrap_err();
        assert!(!touched.load(Ordering::SeqCst), "{error:?}");
        assert_eq!(server.requests().len(), 1);
        let text = format!("{error} {error:?}");
        assert!(
            !text.contains("BODY_SECRET") && !text.contains("127.0.0.1"),
            "{text}"
        );
    }
}

#[tokio::test]
async fn invalid_content_type_is_rejected_before_creating_a_document() {
    let server = serve(|_, _, _| json(201, "{}")).await;
    for content_type in ["", "bad\r\ntype"] {
        let error = client(&server.url)
            .workflows()
            .create_and_upload_feed_document(
                content_type,
                chunks(&[b"x"]),
                UploadOptions::default(),
            )
            .await
            .unwrap_err();
        assert!(matches!(error, WorkflowError::InvalidConfig), "{error:?}");
    }
    assert!(server.requests().is_empty());
}

#[tokio::test]
async fn upload_rejection_and_failure_retain_the_document_id() {
    let server = serve(|_, request, base| {
        if request.starts_with("PUT /signed") {
            http(403, "", b"upload denied")
        } else {
            json(
                201,
                &format!(
                    "{{\"feedDocumentId\":\"fd9\",\"url\":\"{base}/signed?sig=SIGNED_SECRET\"}}"
                ),
            )
        }
    })
    .await;
    let uploaded = client(&server.url)
        .workflows()
        .create_and_upload_feed_document("text/xml", chunks(&[b"x"]), UploadOptions::default())
        .await
        .unwrap();
    assert_eq!(uploaded.document_id, "fd9");
    assert_eq!(uploaded.response.status, 403);
    assert_eq!(uploaded.response.body, b"upload denied");
    assert_eq!(server.count("PUT /signed"), 1, "no retry");
    assert_eq!(server.count("POST /feeds"), 1, "no retry");

    let server = serve(|_, request, base| {
        if request.starts_with("PUT /signed") {
            http(200, "", b"")
        } else {
            json(
                201,
                &format!(
                    "{{\"feedDocumentId\":\"fd9\",\"url\":\"{base}/signed?sig=SIGNED_SECRET\"}}"
                ),
            )
        }
    })
    .await;
    let failing = stream::iter([Ok(Bytes::from_static(b"x")), Err("SOURCE_SECRET")]);
    let error = client(&server.url)
        .workflows()
        .create_and_upload_feed_document("text/xml", failing, UploadOptions::default())
        .await
        .unwrap_err();
    assert_eq!(error.document_id(), Some("fd9"));
    assert!(matches!(
        error,
        WorkflowError::Upload {
            error: DocumentError::UploadSource,
            ..
        }
    ));
    let text = format!("{error} {error:?}");
    assert!(
        !text.contains("SIGNED_SECRET") && !text.contains("SOURCE_SECRET"),
        "{text}"
    );
}

#[tokio::test]
async fn one_deadline_covers_create_and_upload() {
    let calls = Arc::new(AtomicUsize::new(0));
    let seen = calls.clone();
    let server = serve(move |_, request, base| {
        seen.fetch_add(1, Ordering::SeqCst);
        if request.starts_with("PUT /signed") {
            http(200, "", b"").delayed(Duration::from_secs(2))
        } else {
            json(
                201,
                &format!("{{\"feedDocumentId\":\"fd1\",\"url\":\"{base}/signed\"}}"),
            )
            .delayed(Duration::from_millis(300))
        }
    })
    .await;
    let started = Instant::now();
    let error = client(&server.url)
        .workflows()
        .create_and_upload_feed_document(
            "text/xml",
            chunks(&[b"x"]),
            UploadOptions {
                transfer: TransferOptions {
                    timeout: Duration::from_millis(600),
                    ..Default::default()
                },
                ..Default::default()
            },
        )
        .await
        .unwrap_err();
    assert_eq!(error.document_id(), Some("fd1"));
    assert!(
        matches!(
            error,
            WorkflowError::Upload {
                error: DocumentError::Timeout,
                ..
            }
        ),
        "{error:?}"
    );
    let elapsed = started.elapsed();
    assert!(
        elapsed >= Duration::from_millis(550) && elapsed < Duration::from_millis(900),
        "{elapsed:?}"
    );
    assert_eq!(calls.load(Ordering::SeqCst), 2);
    let _ = stream::empty::<Result<Bytes, ()>>().next().await;
}

#[tokio::test]
async fn create_and_upload_can_be_split_without_hiding_the_signed_url() {
    let server = serve(|_, request, base| {
        if request.starts_with("PUT /signed") {
            http(200, "", b"")
        } else {
            json(
                201,
                &format!(
                    "{{\"feedDocumentId\":\"fd2\",\"url\":\"{base}/signed?sig=SIGNED_SECRET\"}}"
                ),
            )
        }
    })
    .await;
    let workflows = client(&server.url).workflows();
    let options = UploadOptions::default();
    let target = workflows
        .create_feed_document("text/xml", &options)
        .await
        .unwrap();
    assert_eq!(target.document_id, "fd2");
    assert!(!format!("{target:?}").contains("SIGNED_SECRET"));
    assert_eq!(server.requests().len(), 1);
    let uploaded = target.upload(chunks(&[b"<x/>"]), options).await.unwrap();
    assert_eq!(uploaded.response.status, 200);
    assert!(
        server.requests()[1]
            .to_lowercase()
            .contains("content-type: text/xml")
    );
}
