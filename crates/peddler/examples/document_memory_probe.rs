//! Isolated streaming memory probe: cargo run -p peddler --example
//! document_memory_probe -- 128 [gzip]. Measure the executable with /usr/bin/time
//! -l on macOS or -v on Linux. Server and consumer share this process; no fixture
//! or whole-response buffer. Increase to 512 to compare peak RSS.
use peddler::{Client, documents::TransferOptions};
use std::time::{Duration, Instant};
use tokio::{
    io::{AsyncReadExt, AsyncWriteExt},
    net::TcpListener,
};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mib: u64 = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "128".into())
        .parse()?;
    let gzip = std::env::args().nth(2).is_some_and(|arg| arg == "gzip");
    let total = mib.checked_mul(1 << 20).ok_or("size overflow")?;
    let listener = TcpListener::bind("127.0.0.1:0").await?;
    let url = format!("http://{}", listener.local_addr()?);
    let server = tokio::spawn(async move {
        let (mut socket, _) = listener.accept().await?;
        let mut request = Vec::new();
        while !request.windows(4).any(|bytes| bytes == b"\r\n\r\n") {
            let mut byte = [0];
            socket.read_exact(&mut byte).await?;
            request.push(byte[0]);
        }
        let header = if gzip {
            "HTTP/1.1 200 OK\r\nContent-Encoding: gzip\r\nConnection: close\r\n\r\n".to_string()
        } else {
            format!("HTTP/1.1 200 OK\r\nContent-Length: {total}\r\n\r\n")
        };
        socket.write_all(header.as_bytes()).await?;
        let mut writer: std::pin::Pin<Box<dyn tokio::io::AsyncWrite + Send>> = if gzip {
            Box::pin(async_compression::tokio::write::GzipEncoder::new(socket))
        } else {
            Box::pin(socket)
        };
        let block = [b'x'; 64 << 10];
        let mut remaining = total;
        while remaining > 0 {
            let size = remaining.min(block.len() as u64) as usize;
            writer.write_all(&block[..size]).await?;
            remaining -= size as u64;
        }
        writer.shutdown().await?;
        Ok::<_, std::io::Error>(())
    });
    let started = Instant::now();
    let options = TransferOptions {
        timeout: Duration::from_secs(300),
        max_bytes: total.max(1),
        ..Default::default()
    };
    let bytes = Client::new(&url, "unused")?
        .documents()
        .download(&url, options)
        .await?
        .copy_to(&mut tokio::io::sink())
        .await?;
    server.await??;
    if bytes != total {
        return Err("unexpected byte count".into());
    }
    println!(
        "bytes={bytes} gzip={gzip} elapsed_seconds={:.3}",
        started.elapsed().as_secs_f64()
    );
    Ok(())
}
