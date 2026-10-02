use bytes::Bytes;
use futures_util::{StreamExt, stream};
use peddler::{
    Client,
    documents::{Compression, Error, TransferOptions, UploadOptions},
};
use std::{io, time::Duration};
use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::TcpListener,
};

async fn server(response: Vec<u8>, delay: Duration) -> (String, tokio::task::JoinHandle<Vec<u8>>) {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let url = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        let mut request = Vec::new();
        while !request.windows(4).any(|w| w == b"\r\n\r\n") {
            let mut byte = [0];
            socket.read_exact(&mut byte).await.unwrap();
            request.push(byte[0]);
        }
        tokio::time::sleep(delay).await;
        let _ = socket.write_all(&response).await;
        request
    });
    (url, task)
}
fn response(body: &[u8], headers: &str) -> Vec<u8> {
    let mut out = format!(
        "HTTP/1.1 200 OK\r\nContent-Length: {}\r\n{headers}\r\n",
        body.len()
    )
    .into_bytes();
    out.extend_from_slice(body);
    out
}
fn client(url: &str) -> Client {
    Client::new(url, "SECRET_API_TOKEN").unwrap()
}

#[tokio::test]
async fn signed_query_duplicate_headers_and_no_token() {
    let (url, task) = server(
        response(b"hello", "X-Copy: a\r\nX-Copy: b\r\n"),
        Duration::ZERO,
    )
    .await;
    // A wrapper names its host to the Selling Partner API only, never to a signed URL.
    let mut config = peddler::ClientConfig::new(&url, "SECRET_API_TOKEN");
    config.user_agent = Some("Wrapper/1 (Language=Test; private-host)".into());
    config.pool = Some(peddler::Pool::with_user_agent("Wrapper/1 (Language=Test)").unwrap());
    let doc = Client::with_config(config)
        .unwrap()
        .documents()
        .download(
            &format!("{url}/file?z=%2f&a=1&a=2&sig=secret+value"),
            TransferOptions::default(),
        )
        .await
        .unwrap();
    assert_eq!(doc.status(), 200);
    assert_eq!(doc.headers().get_all("x-copy").iter().count(), 2);
    let bytes = doc
        .into_chunks()
        .try_collect::<Vec<_>>()
        .await
        .unwrap()
        .concat();
    assert_eq!(bytes, b"hello");
    let request = String::from_utf8(task.await.unwrap()).unwrap();
    assert!(request.starts_with("GET /file?z=%2f&a=1&a=2&sig=secret+value HTTP/1.1"));
    assert!(!request.to_lowercase().contains("x-amz-access-token"));
    assert!(!request.to_lowercase().contains("x-amz-date"));
    assert!(!request.contains("SECRET_API_TOKEN"));
    assert!(request.contains("user-agent: Wrapper/1 (Language=Test)\r\n"));
    assert!(!request.contains("private-host"));
}
use futures_util::TryStreamExt;

#[tokio::test]
async fn redirect_is_raw_and_format_readers_reject_non_success() {
    let (url, task) = server(b"HTTP/1.1 302 Found\r\nLocation: http://127.0.0.1:1/secret\r\nContent-Length: 3\r\n\r\nBAD".to_vec(), Duration::ZERO).await;
    let doc = client(&url)
        .documents()
        .download(&url, TransferOptions::default())
        .await
        .unwrap();
    assert_eq!(doc.status(), 302);
    assert_eq!(doc.error_body(), Some(&b"BAD"[..]));
    assert_eq!(
        doc.into_jsonl().next().await.unwrap().unwrap_err(),
        Error::Status
    );
    task.await.unwrap();
}

#[tokio::test]
async fn jsonl_split_utf8_precision_blank_lines_and_final_record() {
    let body =
        b"\r\n{\"n\":123456789012345678901234567890,\"s\":\"\xc3\xa9\"}\r\n \t\n{\"x\":true}";
    let (url, task) = server(response(body, ""), Duration::ZERO).await;
    let rows = client(&url)
        .documents()
        .download(&url, TransferOptions::default())
        .await
        .unwrap()
        .into_jsonl()
        .try_collect::<Vec<_>>()
        .await
        .unwrap();
    assert_eq!(rows.len(), 2);
    assert_eq!(rows[0]["s"], "é");
    assert_eq!(rows[0]["n"].to_string(), "123456789012345678901234567890");
    task.await.unwrap();
}

#[tokio::test]
async fn tsv_quoted_newlines_tabs_quotes_empty_fields_and_final_row() {
    let body = b"a\t\"b\tc\"\t\"d\r\ne\"\t\"f\"\"g\"\t\r\n\tlast\t\t\t";
    let (url, task) = server(response(body, ""), Duration::ZERO).await;
    let rows = client(&url)
        .documents()
        .download(&url, TransferOptions::default())
        .await
        .unwrap()
        .into_tsv(false)
        .try_collect::<Vec<_>>()
        .await
        .unwrap();
    assert_eq!(
        rows,
        vec![
            vec!["a", "b\tc", "d\r\ne", "f\"g", ""],
            vec!["", "last", "", "", ""]
        ]
    );
    task.await.unwrap();
}

#[tokio::test]
async fn byte_record_and_row_limits_are_independent() {
    for (options, expected) in [
        (
            TransferOptions {
                max_bytes: 3,
                ..Default::default()
            },
            Error::ByteLimit,
        ),
        (
            TransferOptions {
                max_record_bytes: 2,
                ..Default::default()
            },
            Error::RecordLimit,
        ),
        (
            TransferOptions {
                max_records: 1,
                ..Default::default()
            },
            Error::RowLimit,
        ),
    ] {
        let (url, task) = server(response(b"{\"x\":1}\n{\"x\":2}\n", ""), Duration::ZERO).await;
        let result = client(&url)
            .documents()
            .download(&url, options)
            .await
            .unwrap()
            .into_jsonl()
            .try_collect::<Vec<_>>()
            .await;
        assert_eq!(result.unwrap_err(), expected);
        task.await.unwrap();
    }
}

#[tokio::test]
async fn invalid_urls_and_config_are_sanitized() {
    let documents = client("https://example.com").documents();
    for url in [
        "http://example.com/secret",
        "https://user:secret@example.com",
        "https://example.com/#secret",
        "https://example.com/a b",
        "https://example.com/a\\b",
        "invalid-secret",
    ] {
        let error = documents
            .download(url, TransferOptions::default())
            .await
            .err()
            .unwrap();
        assert_eq!(error, Error::InvalidUrl);
        assert!(!format!("{error:?} {error}").contains("secret"));
        assert!(std::error::Error::source(&error).is_none());
    }
    assert_eq!(
        documents
            .download(
                "https://example.com",
                TransferOptions {
                    timeout: Duration::ZERO,
                    ..Default::default()
                }
            )
            .await
            .err()
            .unwrap(),
        Error::InvalidConfig
    );
}

#[tokio::test]
async fn deadline_covers_body_and_does_not_reset_between_reads() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let url = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        read_request(&mut socket).await.unwrap();
        socket
            .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\na")
            .await
            .unwrap();
        tokio::time::sleep(Duration::from_millis(250)).await;
        let _ = socket.write_all(b"b").await;
    });
    let mut chunks = client(&url)
        .documents()
        .download(
            &url,
            TransferOptions {
                timeout: Duration::from_millis(100),
                ..Default::default()
            },
        )
        .await
        .unwrap()
        .into_chunks();
    assert_eq!(chunks.next().await.unwrap().unwrap(), "a");
    tokio::time::sleep(Duration::from_millis(150)).await;
    assert_eq!(chunks.next().await.unwrap().unwrap_err(), Error::Timeout);
    task.await.unwrap();
}

#[tokio::test]
async fn upload_preserves_content_type_and_signed_headers() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let url = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        let mut req = Vec::new();
        let mut b = [0];
        while !req.windows(4).any(|w| w == b"\r\n\r\n") {
            socket.read_exact(&mut b).await.unwrap();
            req.push(b[0]);
        }
        let mut body = [0; 6];
        socket.read_exact(&mut body).await.unwrap();
        socket
            .write_all(b"HTTP/1.1 201 Created\r\nContent-Length: 2\r\n\r\nOK")
            .await
            .unwrap();
        (String::from_utf8(req).unwrap(), body)
    });
    let options = UploadOptions {
        content_type: "text/tab-separated-values; charset=UTF-8".into(),
        headers: vec![("x-amz-meta-test".into(), "exact".into())],
        content_length: Some(6),
        ..Default::default()
    };
    let result = client(&url)
        .documents()
        .upload(
            &url,
            stream::iter([
                Ok::<_, io::Error>(Bytes::from_static(b"abc")),
                Ok(Bytes::from_static(b"def")),
            ]),
            options,
        )
        .await
        .unwrap();
    assert_eq!(result.status, 201);
    assert_eq!(result.body, b"OK");
    let (request, body) = task.await.unwrap();
    assert_eq!(&body, b"abcdef");
    assert!(request.contains("content-type: text/tab-separated-values; charset=UTF-8"));
    assert!(request.contains("x-amz-meta-test: exact"));
    assert!(!request.contains("SECRET_API_TOKEN"));
}

#[tokio::test]
async fn upload_rejects_auth_and_framing_headers() {
    for header in [
        "x-amz-access-token",
        "authorization",
        "content-length",
        "transfer-encoding",
        "host",
        "content-type",
    ] {
        let options = UploadOptions {
            headers: vec![(header.into(), "secret".into())],
            ..Default::default()
        };
        assert_eq!(
            client("https://example.com")
                .documents()
                .upload(
                    "https://example.com/secret",
                    stream::empty::<Result<Bytes, io::Error>>(),
                    options
                )
                .await
                .unwrap_err(),
            Error::InvalidHeader
        );
    }
}

async fn chunked_server(body: Vec<u8>, headers: &str) -> (String, tokio::task::JoinHandle<()>) {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let url = format!("http://{}", listener.local_addr().unwrap());
    let header = format!("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n{headers}\r\n");
    let task = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        let mut request = Vec::new();
        while !request.windows(4).any(|w| w == b"\r\n\r\n") {
            let mut byte = [0];
            socket.read_exact(&mut byte).await.unwrap();
            request.push(byte[0]);
        }
        if socket.write_all(header.as_bytes()).await.is_err() {
            return;
        }
        for byte in body {
            if socket
                .write_all(&[b'1', b'\r', b'\n', byte, b'\r', b'\n'])
                .await
                .is_err()
            {
                return;
            }
            tokio::task::yield_now().await;
        }
        let _ = socket.write_all(b"0\r\n\r\n").await;
    });
    (url, task)
}

#[tokio::test]
async fn gzip_header_and_metadata_decode_exactly_once_and_enforce_output_limit() {
    let gzip = vec![
        31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49,
        80, 8, 0, 0, 0,
    ];
    for compression in [Compression::Auto, Compression::Gzip] {
        let (url, task) = chunked_server(gzip.clone(), "Content-Encoding: gzip\r\n").await;
        let rows = client(&url)
            .documents()
            .download(
                &url,
                TransferOptions {
                    compression,
                    ..Default::default()
                },
            )
            .await
            .unwrap()
            .into_jsonl()
            .try_collect::<Vec<_>>()
            .await
            .unwrap();
        assert_eq!(rows, vec![serde_json::json!({"x": 1})]);
        task.await.unwrap();
    }
    let (url, task) = chunked_server(gzip, "").await;
    let error = client(&url)
        .documents()
        .download(
            &url,
            TransferOptions {
                compression: Compression::Gzip,
                max_bytes: 3,
                ..Default::default()
            },
        )
        .await
        .unwrap()
        .into_chunks()
        .try_collect::<Vec<_>>()
        .await
        .unwrap_err();
    assert_eq!(error, Error::ByteLimit);
    task.await.unwrap();
}

#[tokio::test]
async fn gzip_corruption_and_truncation_are_sanitized() {
    let gzip = vec![
        31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49,
        80, 8, 0, 0, 0,
    ];
    for body in [b"secret not gzip".to_vec(), gzip[..gzip.len() - 4].to_vec()] {
        let (url, task) = chunked_server(body, "Content-Encoding: gzip\r\n").await;
        let error = client(&url)
            .documents()
            .download(&url, TransferOptions::default())
            .await
            .unwrap()
            .into_chunks()
            .try_collect::<Vec<_>>()
            .await
            .unwrap_err();
        assert_eq!(error, Error::Compression);
        assert!(std::error::Error::source(&error).is_none());
        task.await.unwrap();
    }
}

#[tokio::test]
async fn split_jsonl_and_tsv_keep_utf8_and_quoted_grammar() {
    for (body, jsonl) in [
        ("{\"x\":\"é\"}\r\n{\"x\":2}", true),
        ("\"é\tmore\"\t\"line\n2\"\r\nlast\t", false),
    ] {
        let (url, task) = chunked_server(body.as_bytes().to_vec(), "").await;
        let doc = client(&url)
            .documents()
            .download(&url, TransferOptions::default())
            .await
            .unwrap();
        if jsonl {
            let rows = doc.into_jsonl().try_collect::<Vec<_>>().await.unwrap();
            assert_eq!(rows[0]["x"], "é");
            assert_eq!(rows.len(), 2);
        } else {
            assert_eq!(
                doc.into_tsv(false).try_collect::<Vec<_>>().await.unwrap(),
                vec![vec!["é\tmore", "line\n2"], vec!["last", ""]]
            );
        }
        task.await.unwrap();
    }
}

#[tokio::test]
async fn unsupported_content_encoding_fails_clearly() {
    for encoding in ["br", "gzip, gzip", "gzip, br"] {
        let (url, task) = server(
            response(b"secret", &format!("Content-Encoding: {encoding}\r\n")),
            Duration::ZERO,
        )
        .await;
        assert_eq!(
            client(&url)
                .documents()
                .download(&url, TransferOptions::default())
                .await
                .err()
                .unwrap(),
            Error::UnsupportedEncoding
        );
        task.await.unwrap();
    }
}

#[tokio::test]
async fn upload_actual_length_and_source_errors_are_sanitized() {
    for (chunks, length, expected) in [
        (
            vec![Ok(Bytes::from_static(b"abc"))],
            6,
            Error::LengthMismatch,
        ),
        (
            vec![
                Ok(Bytes::from_static(b"abc")),
                Ok(Bytes::from_static(b"def")),
            ],
            3,
            Error::LengthMismatch,
        ),
        (
            vec![Err(io::Error::other("secret signed URL payload"))],
            3,
            Error::UploadSource,
        ),
    ] {
        let (url, task) = server(response(b"OK", ""), Duration::from_millis(100)).await;
        let result = client(&url)
            .documents()
            .upload(
                &url,
                stream::iter(chunks),
                UploadOptions {
                    content_length: Some(length),
                    ..Default::default()
                },
            )
            .await;
        assert_eq!(result.unwrap_err(), expected);
        task.abort();
    }
}

#[tokio::test]
async fn tsv_field_count_is_optional_and_all_record_limits_apply() {
    for (options, consistent, expected) in [
        (TransferOptions::default(), true, Error::Format),
        (
            TransferOptions {
                max_record_bytes: 28,
                ..Default::default()
            },
            false,
            Error::RecordLimit,
        ),
        (
            TransferOptions {
                max_records: 1,
                ..Default::default()
            },
            false,
            Error::RowLimit,
        ),
    ] {
        let (url, task) = server(response(b"a\tb\nc\n", ""), Duration::ZERO).await;
        let error = client(&url)
            .documents()
            .download(&url, options)
            .await
            .unwrap()
            .into_tsv(consistent)
            .try_collect::<Vec<_>>()
            .await
            .unwrap_err();
        assert_eq!(error, expected);
        task.await.unwrap();
    }
}

#[tokio::test]
async fn bounded_error_body_is_raw_even_with_gzip_header() {
    let (url, task) = server(
        b"HTTP/1.1 403 Forbidden\r\nContent-Encoding: gzip\r\nContent-Length: 6\r\n\r\nsecret"
            .to_vec(),
        Duration::ZERO,
    )
    .await;
    let doc = client(&url)
        .documents()
        .download(
            &url,
            TransferOptions {
                max_response_bytes: 3,
                ..Default::default()
            },
        )
        .await
        .unwrap();
    assert_eq!(doc.status(), 403);
    assert_eq!(doc.error_body(), Some(&b"sec"[..]));
    assert!(doc.error_body_truncated());
    assert!(!format!("{doc:?}").contains("sec"));
    task.await.unwrap();
}

async fn read_request(socket: &mut tokio::net::TcpStream) -> io::Result<Vec<u8>> {
    let mut bytes = Vec::new();
    while !bytes.windows(4).any(|w| w == b"\r\n\r\n") {
        let mut byte = [0];
        socket.read_exact(&mut byte).await?;
        bytes.push(byte[0]);
    }
    Ok(bytes)
}

#[tokio::test]
async fn drop_releases_socket_and_pool_remains_reusable() {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let url = format!("http://{}", listener.local_addr().unwrap());
    let task = tokio::spawn(async move {
        let (mut first, _) = listener.accept().await.unwrap();
        read_request(&mut first).await.unwrap();
        first
            .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 999999\r\n\r\nx")
            .await
            .unwrap();
        let mut byte = [0];
        let closed = tokio::time::timeout(Duration::from_secs(2), first.read(&mut byte))
            .await
            .unwrap();
        assert!(closed.is_err() || closed.unwrap() == 0);
        let (mut second, _) = listener.accept().await.unwrap();
        for _ in 0..2 {
            read_request(&mut second).await.unwrap();
            second
                .write_all(b"HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK")
                .await
                .unwrap();
        }
    });
    let documents = client(&url).documents();
    let mut chunks = documents
        .download(&url, TransferOptions::default())
        .await
        .unwrap()
        .into_chunks();
    assert_eq!(chunks.next().await.unwrap().unwrap(), "x");
    drop(chunks);
    for _ in 0..2 {
        let result = documents
            .download(&url, TransferOptions::default())
            .await
            .unwrap()
            .into_chunks()
            .try_collect::<Vec<_>>()
            .await
            .unwrap()
            .concat();
        assert_eq!(result, b"OK");
    }
    tokio::time::timeout(Duration::from_secs(2), task)
        .await
        .unwrap()
        .unwrap();
}

#[tokio::test]
async fn bounded_whole_json() {
    let (url, task) = server(response(b"{\"x\":1}", ""), Duration::ZERO).await;
    let result = client(&url)
        .documents()
        .download(&url, TransferOptions::default())
        .await
        .unwrap()
        .json(4)
        .await;
    assert_eq!(result.unwrap_err(), Error::ByteLimit);
    task.await.unwrap();
    let (url, task) = server(response(b"{\"x\":1}", ""), Duration::ZERO).await;
    assert_eq!(
        client(&url)
            .documents()
            .download(&url, TransferOptions::default())
            .await
            .unwrap()
            .json(64)
            .await
            .unwrap(),
        serde_json::json!({"x":1})
    );
    task.await.unwrap();
}

#[tokio::test]
async fn document_deadline_overrides_shorter_api_timeout() {
    let (url, task) = server(response(b"OK", ""), Duration::from_millis(80)).await;
    let doc = Client::with_timeout(&url, "secret", Duration::from_millis(10))
        .unwrap()
        .documents()
        .download(
            &url,
            TransferOptions {
                timeout: Duration::from_millis(500),
                ..Default::default()
            },
        )
        .await
        .unwrap();
    assert_eq!(
        doc.into_chunks()
            .try_collect::<Vec<_>>()
            .await
            .unwrap()
            .concat(),
        b"OK"
    );
    task.await.unwrap();
}

#[tokio::test]
async fn raw_compression_none_and_metadata_only_are_explicit() {
    let gzip = vec![
        31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49,
        80, 8, 0, 0, 0,
    ];
    let (url, task) = server(
        response(&gzip, "Content-Encoding: gzip\r\n"),
        Duration::ZERO,
    )
    .await;
    assert_eq!(
        client(&url)
            .documents()
            .download(
                &url,
                TransferOptions {
                    compression: Compression::None,
                    ..Default::default()
                }
            )
            .await
            .unwrap()
            .into_chunks()
            .try_collect::<Vec<_>>()
            .await
            .unwrap()
            .concat(),
        gzip
    );
    task.await.unwrap();
    let (url, task) = chunked_server(gzip, "").await;
    assert_eq!(
        client(&url)
            .documents()
            .download(
                &url,
                TransferOptions {
                    compression: Compression::Gzip,
                    ..Default::default()
                }
            )
            .await
            .unwrap()
            .into_chunks()
            .try_collect::<Vec<_>>()
            .await
            .unwrap()
            .concat(),
        b"{\"x\":1}\n"
    );
    task.await.unwrap();
}

#[tokio::test]
async fn upload_zero_length_is_checked_and_reply_is_bounded() {
    let docs = client("https://example.com").documents();
    assert_eq!(
        docs.upload(
            "https://example.com",
            stream::iter([Ok::<_, io::Error>(Bytes::from_static(b"extra"))]),
            UploadOptions {
                content_length: Some(0),
                ..Default::default()
            }
        )
        .await
        .unwrap_err(),
        Error::LengthMismatch
    );
    let (url, task) = server(response(b"secret", ""), Duration::ZERO).await;
    let result = client(&url)
        .documents()
        .upload(
            &url,
            stream::empty::<Result<Bytes, io::Error>>(),
            UploadOptions {
                content_length: Some(0),
                transfer: TransferOptions {
                    max_response_bytes: 3,
                    ..Default::default()
                },
                ..Default::default()
            },
        )
        .await
        .unwrap();
    assert_eq!(result.body, b"sec");
    assert!(result.body_truncated);
    assert!(!format!("{result:?}").contains("sec"));
    task.await.unwrap();
}

#[tokio::test]
async fn parse_errors_do_not_include_document_contents() {
    let (url, task) = server(response(b"secret invalid JSON\n", ""), Duration::ZERO).await;
    let error = client(&url)
        .documents()
        .download(&url, TransferOptions::default())
        .await
        .unwrap()
        .into_jsonl()
        .next()
        .await
        .unwrap()
        .unwrap_err();
    assert_eq!(error, Error::Format);
    assert!(!format!("{error:?} {error}").contains("secret"));
    assert!(std::error::Error::source(&error).is_none());
    task.await.unwrap();
}

#[tokio::test]
async fn concatenated_gzip_members_decode_as_one_layer() {
    let member = vec![
        31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49,
        80, 8, 0, 0, 0,
    ];
    let (url, task) = chunked_server(
        [member.clone(), member.clone()].concat(),
        "Content-Encoding: gzip\r\n",
    )
    .await;
    let rows = client(&url)
        .documents()
        .download(
            &url,
            TransferOptions {
                compression: Compression::Gzip,
                ..Default::default()
            },
        )
        .await
        .unwrap()
        .into_jsonl()
        .try_collect::<Vec<_>>()
        .await
        .unwrap();
    assert_eq!(
        rows,
        vec![serde_json::json!({"x":1}), serde_json::json!({"x":1})]
    );
    task.await.unwrap();
}

async fn trailing_gzip_error(tail: Vec<u8>) {
    let member = vec![
        31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49,
        80, 8, 0, 0, 0,
    ];
    let (url, task) = chunked_server([member, tail].concat(), "Content-Encoding: gzip\r\n").await;
    let error = client(&url)
        .documents()
        .download(&url, TransferOptions::default())
        .await
        .unwrap()
        .into_chunks()
        .try_collect::<Vec<_>>()
        .await
        .unwrap_err();
    assert_eq!(error, Error::Compression);
    assert!(std::error::Error::source(&error).is_none());
    task.await.unwrap();
}
#[tokio::test]
async fn gzip_corrupt_trailing_member_is_rejected() {
    trailing_gzip_error(b"secret corrupt trailing bytes".to_vec()).await;
}
#[tokio::test]
async fn gzip_truncated_trailing_member_is_rejected() {
    trailing_gzip_error(vec![
        31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49,
        80,
    ])
    .await;
}

#[tokio::test]
async fn early_upload_rejection_preserves_raw_response_with_declared_length() {
    let (url, task) = server(
        b"HTTP/1.1 413 Too Large\r\nContent-Length: 3\r\nConnection: close\r\n\r\nBAD".to_vec(),
        Duration::ZERO,
    )
    .await;
    let source = stream::once(std::future::ready(Ok::<_, ()>(Bytes::from_static(
        b"first",
    ))))
    .chain(stream::pending());
    let response = client(&url)
        .documents()
        .upload(
            &url,
            source,
            UploadOptions {
                content_length: Some(1 << 30),
                ..UploadOptions::default()
            },
        )
        .await
        .unwrap();
    assert_eq!(response.status, 413);
    assert_eq!(response.body, b"BAD");
    task.await.unwrap();
}

// Charset decoding.

/// One HTTP chunk per part, flushed and paused so each arrives on its own.
async fn parts_server(parts: Vec<Vec<u8>>, headers: &str) -> (String, tokio::task::JoinHandle<()>) {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let url = format!("http://{}", listener.local_addr().unwrap());
    let header = format!("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\n{headers}\r\n");
    let task = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await.unwrap();
        let mut request = Vec::new();
        while !request.windows(4).any(|w| w == b"\r\n\r\n") {
            let mut byte = [0];
            socket.read_exact(&mut byte).await.unwrap();
            request.push(byte[0]);
        }
        if socket.write_all(header.as_bytes()).await.is_err() {
            return;
        }
        for part in parts {
            let mut frame = format!("{:x}\r\n", part.len()).into_bytes();
            frame.extend_from_slice(&part);
            frame.extend_from_slice(b"\r\n");
            if socket.write_all(&frame).await.is_err() || socket.flush().await.is_err() {
                return;
            }
            tokio::time::sleep(Duration::from_millis(30)).await;
        }
        let _ = socket.write_all(b"0\r\n\r\n").await;
    });
    (url, task)
}
async fn tsv(
    parts: Vec<Vec<u8>>,
    headers: &str,
    charset: Option<&str>,
) -> Result<Vec<Vec<String>>, Error> {
    let (url, task) = parts_server(parts, headers).await;
    let doc = client(&url)
        .documents()
        .download(&url, TransferOptions::default())
        .await
        .unwrap();
    let rows = match charset {
        Some(label) => doc.into_tsv_with_charset(false, label),
        None => doc.into_tsv(false),
    }
    .try_collect::<Vec<_>>()
    .await;
    let _ = task.await;
    rows
}
fn cp1252() -> Vec<u8> {
    b"name\tprice\ncaf\xE9\t5\xA0\xE2\x82\nm\xFCller\t\x805\n".to_vec()
}
fn cp1252_rows() -> Vec<Vec<String>> {
    vec![
        vec!["name".into(), "price".into()],
        vec!["caf\u{e9}".into(), "5\u{a0}\u{e2}\u{201a}".into()],
        vec!["m\u{fc}ller".into(), "\u{20ac}5".into()],
    ]
}

#[tokio::test]
async fn cp1252_and_iso_8859_1_labels_decode_to_utf8() {
    for label in ["Cp1252", "ISO-8859-1", "windows-1252", "latin1"] {
        let headers = format!("Content-Type: text/plain; charset={label}\r\n");
        let rows = tsv(vec![cp1252()], &headers, None).await.unwrap();
        assert_eq!(rows[1][0], "caf\u{e9}", "{label}");
        assert_eq!(rows[2][0], "m\u{fc}ller", "{label}");
    }
    let rows = tsv(
        vec![cp1252()],
        "Content-Type: text/plain; charset=\"Cp1252\"\r\n",
        None,
    )
    .await
    .unwrap();
    assert_eq!(rows, cp1252_rows());
}

#[tokio::test]
async fn shift_jis_character_split_across_chunks_decodes() {
    // "日本" is 93 FA 96 7B in Shift_JIS; split inside each character.
    let body = vec![
        b"a\t\x93".to_vec(),
        b"\xFA\x96".to_vec(),
        b"\x7B\nb\t\x82".to_vec(),
        b"\xA0\n".to_vec(),
    ];
    for label in ["Shift_JIS", "windows-31j", "Cp932"] {
        let headers = format!("Content-Type: text/plain; charset={label}\r\n");
        let rows = tsv(body.clone(), &headers, None).await.unwrap();
        assert_eq!(
            rows,
            vec![vec!["a", "\u{65e5}\u{672c}"], vec!["b", "\u{3042}"]],
            "{label}"
        );
    }
}

#[tokio::test]
async fn gzip_and_legacy_charset_together() {
    use async_compression::tokio::bufread::GzipEncoder;
    let mut gzip = Vec::new();
    let body = cp1252();
    GzipEncoder::new(&body[..])
        .read_to_end(&mut gzip)
        .await
        .unwrap();
    let parts = gzip.chunks(7).map(<[u8]>::to_vec).collect();
    let rows = tsv(
        parts,
        "Content-Type: text/plain; charset=Cp1252\r\nContent-Encoding: gzip\r\n",
        None,
    )
    .await
    .unwrap();
    assert_eq!(rows, cp1252_rows());
}

#[tokio::test]
async fn no_charset_means_utf8_and_stray_bytes_fail() {
    let ok = tsv(vec!["é\t€\n".as_bytes().to_vec()], "", None)
        .await
        .unwrap();
    assert_eq!(ok, vec![vec!["é", "€"]]);
    let error = tsv(vec![b"caf\xE9\t1\n".to_vec()], "", None)
        .await
        .unwrap_err();
    assert_eq!(error, Error::Format);
}

#[tokio::test]
async fn unknown_label_and_invalid_bytes_are_fixed_errors() {
    let secret = b"SECRET\t1\n".to_vec();
    let error = tsv(
        vec![secret.clone()],
        "Content-Type: text/plain; charset=SECRET-9\r\n",
        None,
    )
    .await
    .unwrap_err();
    assert_eq!(error, Error::UnsupportedCharset);
    assert_eq!(error.to_string(), "unsupported document charset");
    let error = tsv(vec![secret], "", Some("SECRET-9")).await.unwrap_err();
    assert_eq!(error, Error::UnsupportedCharset);
    // 0x81 0x20 is not a valid Shift_JIS sequence; a lone lead byte at EOF is not either.
    for body in [b"a\x81 \n".to_vec(), b"a\t\x93".to_vec()] {
        let error = tsv(
            vec![body],
            "Content-Type: text/plain; charset=Shift_JIS\r\n",
            None,
        )
        .await
        .unwrap_err();
        assert_eq!(error, Error::Format);
    }
}

#[tokio::test]
async fn override_wins_over_header_and_missing_header() {
    let rows = tsv(
        vec![cp1252()],
        "Content-Type: text/plain; charset=utf-8\r\n",
        Some("cp1252"),
    )
    .await
    .unwrap();
    assert_eq!(rows, cp1252_rows());
    let rows = tsv(vec![cp1252()], "", Some("Cp1252")).await.unwrap();
    assert_eq!(rows, cp1252_rows());
}

#[tokio::test]
async fn charset_reader_reports_the_header_label() {
    for (headers, expected) in [
        (
            "Content-Type: text/plain; charset=Cp1252\r\n",
            Some("Cp1252"),
        ),
        (
            "Content-Type: text/plain; Charset=\"utf-8\"\r\n",
            Some("utf-8"),
        ),
        ("Content-Type: text/plain\r\n", None),
        ("", None),
    ] {
        let (url, task) = parts_server(vec![b"a\n".to_vec()], headers).await;
        let doc = client(&url)
            .documents()
            .download(&url, TransferOptions::default())
            .await
            .unwrap();
        assert_eq!(doc.charset().as_deref(), expected);
        drop(doc.into_chunks());
        let _ = task.await;
    }
}

#[tokio::test]
async fn utf8_byte_order_mark_is_dropped_even_when_split() {
    let rows = tsv(vec![b"\xEF".to_vec(), b"\xBB\xBFa\tb\n".to_vec()], "", None)
        .await
        .unwrap();
    assert_eq!(rows, vec![vec!["a", "b"]]);
}

#[tokio::test]
async fn chunks_stay_raw_bytes_and_jsonl_stays_utf8() {
    let (url, task) = parts_server(
        vec![cp1252()],
        "Content-Type: text/plain; charset=Cp1252\r\n",
    )
    .await;
    let chunks = client(&url)
        .documents()
        .download(&url, TransferOptions::default())
        .await
        .unwrap()
        .into_chunks()
        .try_collect::<Vec<_>>()
        .await
        .unwrap();
    assert_eq!(chunks.concat(), cp1252());
    task.await.unwrap();
}

#[tokio::test]
async fn limits_count_bytes_after_decoding_for_records() {
    // 2 Cp1252 bytes become 6 UTF-8 bytes (euro sign x2), which exceeds a 5 byte record.
    let (url, task) = parts_server(
        vec![b"\x80\x80\n".to_vec()],
        "Content-Type: text/plain; charset=Cp1252\r\n",
    )
    .await;
    let error = client(&url)
        .documents()
        .download(
            &url,
            TransferOptions {
                max_record_bytes: 5,
                ..Default::default()
            },
        )
        .await
        .unwrap()
        .into_tsv(false)
        .try_collect::<Vec<_>>()
        .await
        .unwrap_err();
    assert_eq!(error, Error::RecordLimit);
    let _ = task.await;
}

#[tokio::test]
async fn recorded_gzip_cp1252_report_replays() {
    // Recorded from SP-API: Content-Type "text/plain; charset=Cp1252",
    // Content-Encoding gzip. The recorded body is ASCII only.
    let body = std::fs::read(concat!(
        env!("CARGO_MANIFEST_DIR"),
        "/tests/fixtures/cp1252_report.tsv.gz"
    ))
    .unwrap();
    let (url, task) = chunked_server(
        body,
        "Content-Type: text/plain; charset=Cp1252\r\nContent-Encoding: gzip\r\n",
    )
    .await;
    let rows = client(&url)
        .documents()
        .download(&url, TransferOptions::default())
        .await
        .unwrap()
        .into_tsv(true)
        .try_collect::<Vec<_>>()
        .await
        .unwrap();
    assert_eq!(rows.len(), 11);
    assert_eq!(
        &rows[0][..3],
        ["item-name", "item-description", "listing-id"]
    );
    assert_eq!(rows[1][0], "Sample Listing Title One");
    assert_eq!(rows[1][3], "SKU-001-TEST");
    task.await.unwrap();
}
