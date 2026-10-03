//! A loopback HTTP/1.1 server for the integration tests.
#![allow(dead_code)]

use std::{
    sync::{Arc, Mutex},
    time::Duration,
};
use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::{TcpListener, TcpStream},
};

/// `{"x":1}` and a newline, gzipped.
pub const GZIP: [u8; 28] = [
    31, 139, 8, 0, 0, 0, 0, 0, 2, 255, 171, 86, 170, 80, 178, 50, 172, 229, 2, 0, 21, 240, 49, 80,
    8, 0, 0, 0,
];

/// What a connection gets back: the bytes, written after `delay`, then the socket stays
/// open for `hold`.
#[derive(Clone)]
pub struct Reply {
    pub bytes: Vec<u8>,
    pub delay: Duration,
    pub hold: Duration,
}

impl Reply {
    /// Bytes written as they are.
    pub fn raw(bytes: impl Into<Vec<u8>>) -> Self {
        Self {
            bytes: bytes.into(),
            delay: Duration::ZERO,
            hold: Duration::ZERO,
        }
    }

    pub fn delayed(mut self, delay: Duration) -> Self {
        self.delay = delay;
        self
    }

    pub fn held(mut self, hold: Duration) -> Self {
        self.hold = hold;
        self
    }
}

/// A complete response that closes its connection. `headers` are whole lines.
pub fn http(status: u16, headers: &str, body: &[u8]) -> Reply {
    let head = format!(
        "HTTP/1.1 {status} Test\r\nContent-Length: {}\r\nConnection: close\r\n{headers}\r\n",
        body.len()
    );
    Reply::raw([head.as_bytes(), body].concat())
}

pub struct Server {
    pub url: String,
    requests: Arc<Mutex<Vec<String>>>,
}

impl Server {
    /// Every request so far, head and body.
    pub fn requests(&self) -> Vec<String> {
        self.requests.lock().unwrap().clone()
    }

    pub fn count(&self, prefix: &str) -> usize {
        self.requests()
            .iter()
            .filter(|request| request.starts_with(prefix))
            .count()
    }
}

/// A loopback listener and its base URL.
pub async fn bind() -> (TcpListener, String) {
    let listener = TcpListener::bind("127.0.0.1:0").await.unwrap();
    let url = format!("http://{}", listener.local_addr().unwrap());
    (listener, url)
}

/// Answers each connection with what the handler returns for its request. The handler
/// gets the index of the connection, the request and the base URL.
pub async fn serve(handler: impl Fn(usize, &str, &str) -> Reply + Send + Sync + 'static) -> Server {
    let (listener, url) = bind().await;
    let requests = Arc::new(Mutex::new(Vec::new()));
    let (log, base, handler) = (requests.clone(), url.clone(), Arc::new(handler));
    tokio::spawn(async move {
        let mut index = 0;
        while let Ok((mut socket, _)) = listener.accept().await {
            let (log, base, handler) = (log.clone(), base.clone(), handler.clone());
            let current = index;
            index += 1;
            tokio::spawn(async move {
                let bytes = read_request(&mut socket).await;
                if head_end(&bytes).is_none() {
                    return;
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

/// Answers the first connection with the first reply, the second with the second, and
/// so on.
pub async fn replies(replies: Vec<Reply>) -> Server {
    serve(move |index, _, _| replies[index].clone()).await
}

/// Reads up to the end of the head, or until the peer closes.
pub async fn read_head(stream: &mut TcpStream) -> Vec<u8> {
    let mut bytes = Vec::new();
    while head_end(&bytes).is_none() && read_more(stream, &mut bytes).await > 0 {}
    bytes
}

/// Reads one request, head and body, or until the peer closes.
pub async fn read_request(stream: &mut TcpStream) -> Vec<u8> {
    let mut bytes = read_head(stream).await;
    let Some(end) = head_end(&bytes) else {
        return bytes;
    };
    let head = String::from_utf8_lossy(&bytes[..end]).to_ascii_lowercase();
    let length = head
        .lines()
        .find_map(|line| line.strip_prefix("content-length: ")?.parse::<usize>().ok());
    let chunked = head.contains("transfer-encoding: chunked");
    while (length.is_some_and(|length| bytes.len() - end < length)
        || chunked && !bytes.ends_with(b"0\r\n\r\n"))
        && read_more(stream, &mut bytes).await > 0
    {}
    bytes
}

async fn read_more(stream: &mut TcpStream, bytes: &mut Vec<u8>) -> usize {
    let mut buffer = [0; 4096];
    let count = stream.read(&mut buffer).await.unwrap_or(0);
    bytes.extend_from_slice(&buffer[..count]);
    count
}

fn head_end(bytes: &[u8]) -> Option<usize> {
    bytes
        .windows(4)
        .position(|window| window == b"\r\n\r\n")
        .map(|position| position + 4)
}
