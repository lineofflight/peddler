//! Signed document transfers. No API credentials, retries, or redirects.
//!
//! Download bodies are streamed, including incremental GZIP decoding. JSONL skips
//! whitespace-only lines; TSV uses the csv-core grammar with tab delimiters.
//! Record limits bound raw record buffers and TSV materialized field storage.
//! Whole JSON decoding is explicitly buffered and requires its own byte limit.

use async_compression::tokio::bufread::GzipDecoder;
use bytes::Bytes;
use futures_util::{Stream, StreamExt, TryStreamExt};
use reqwest::{
    Url,
    header::{CONTENT_ENCODING, CONTENT_LENGTH, CONTENT_TYPE, HeaderMap, HeaderName, HeaderValue},
};
use std::{
    fmt, io,
    pin::Pin,
    sync::{
        Arc,
        atomic::{AtomicU8, AtomicU64, Ordering},
    },
    time::Duration,
};
use tokio::{
    io::{AsyncRead, AsyncReadExt, AsyncWrite, AsyncWriteExt, BufReader},
    time::{Instant, timeout_at},
};
use tokio_util::io::StreamReader;

pub type DocumentStream<T> = Pin<Box<dyn Stream<Item = Result<T, Error>> + Send + 'static>>;

/// Errors never retain caller errors, URLs, headers, or document contents.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Error {
    InvalidConfig,
    InvalidUrl,
    InvalidHeader,
    UnsupportedEncoding,
    Timeout,
    Transport,
    Compression,
    ByteLimit,
    RecordLimit,
    RowLimit,
    Format,
    Status,
    UploadSource,
    LengthMismatch,
    Writer,
}
impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(match self {
            Self::InvalidConfig => "invalid document configuration",
            Self::InvalidUrl => "invalid document URL",
            Self::InvalidHeader => "invalid document header",
            Self::UnsupportedEncoding => "unsupported document encoding",
            Self::Timeout => "document transfer timed out",
            Self::Transport => "document transport failed",
            Self::Compression => "invalid compressed document",
            Self::ByteLimit => "document byte limit exceeded",
            Self::RecordLimit => "document record limit exceeded",
            Self::RowLimit => "document row limit exceeded",
            Self::Format => "invalid document format",
            Self::Status => "document response was not successful",
            Self::UploadSource => "document upload source failed",
            Self::LengthMismatch => "document upload length mismatch",
            Self::Writer => "document writer failed",
        })
    }
}
impl std::error::Error for Error {}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Compression {
    /// Decode a single gzip Content-Encoding. Supply Gzip for SP-API metadata.
    #[default]
    Auto,
    /// Leave bytes encoded, but still reject unsupported/multiple encodings.
    None,
    /// GZIP metadata. Also a gzip header means the same single layer.
    Gzip,
}
#[derive(Clone, Debug)]
pub struct TransferOptions {
    pub timeout: Duration,
    pub compression: Compression,
    /// Ceiling on decompressed bytes, independently of Content-Length.
    pub max_bytes: u64,
    pub max_record_bytes: usize,
    pub max_records: u64,
    /// Non-success responses are raw, bounded, and may be truncated.
    pub max_response_bytes: usize,
}
impl Default for TransferOptions {
    fn default() -> Self {
        Self {
            timeout: Duration::from_secs(30),
            compression: Compression::Auto,
            max_bytes: 1 << 30,
            max_record_bytes: 1 << 20,
            max_records: u64::MAX,
            max_response_bytes: 64 << 10,
        }
    }
}
impl TransferOptions {
    fn deadline(&self) -> Result<Instant, Error> {
        if self.timeout.is_zero()
            || self.max_bytes == 0
            || self.max_record_bytes == 0
            || self.max_records == 0
            || self.max_response_bytes == 0
        {
            return Err(Error::InvalidConfig);
        }
        Instant::now()
            .checked_add(self.timeout)
            .ok_or(Error::InvalidConfig)
    }
}

/// Debug hides signed header values and the content type.
#[derive(Clone)]
pub struct UploadOptions {
    pub transfer: TransferOptions,
    pub content_type: String,
    pub headers: Vec<(String, String)>,
    pub content_length: Option<u64>,
}
impl Default for UploadOptions {
    fn default() -> Self {
        Self {
            transfer: TransferOptions::default(),
            content_type: "application/octet-stream".into(),
            headers: Vec::new(),
            content_length: None,
        }
    }
}
impl fmt::Debug for UploadOptions {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("UploadOptions").finish_non_exhaustive()
    }
}

#[derive(Clone)]
pub struct DocumentClient {
    http: reqwest::Client,
}
impl fmt::Debug for DocumentClient {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("DocumentClient").finish_non_exhaustive()
    }
}
impl crate::Client {
    /// A cheap view sharing the existing pool without the API access token.
    pub fn documents(&self) -> DocumentClient {
        DocumentClient {
            http: self.http.clone(),
        }
    }
}

pub struct Download {
    status: u16,
    headers: HeaderMap,
    body: DocumentStream<Bytes>,
    error_body: Option<Bytes>,
    error_body_truncated: bool,
    options: TransferOptions,
    deadline: Instant,
}
impl fmt::Debug for Download {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Download")
            .field("status", &self.status)
            .finish_non_exhaustive()
    }
}
impl Download {
    pub fn status(&self) -> u16 {
        self.status
    }
    pub fn headers(&self) -> &HeaderMap {
        &self.headers
    }
    pub fn error_body(&self) -> Option<&[u8]> {
        self.error_body.as_deref()
    }
    pub fn error_body_truncated(&self) -> bool {
        self.error_body_truncated
    }
    pub fn into_chunks(self) -> DocumentStream<Bytes> {
        self.body
    }
    fn success(&self) -> Result<(), Error> {
        if (200..300).contains(&self.status) {
            Ok(())
        } else {
            Err(Error::Status)
        }
    }

    pub async fn copy_to<W: AsyncWrite + Unpin + Send>(
        mut self,
        writer: &mut W,
    ) -> Result<u64, Error> {
        self.success()?;
        let mut written = 0;
        while let Some(chunk) = self.body.next().await {
            let chunk = chunk?;
            timeout_at(self.deadline, writer.write_all(&chunk))
                .await
                .map_err(|_| Error::Timeout)?
                .map_err(|_| Error::Writer)?;
            written += chunk.len() as u64;
        }
        timeout_at(self.deadline, writer.flush())
            .await
            .map_err(|_| Error::Timeout)?
            .map_err(|_| Error::Writer)?;
        Ok(written)
    }

    /// Buffered whole JSON, distinct from streaming JSONL. `max_bytes` is required.
    pub async fn json(mut self, max_bytes: usize) -> Result<serde_json::Value, Error> {
        self.success()?;
        if max_bytes == 0 {
            return Err(Error::InvalidConfig);
        }
        let mut bytes = Vec::new();
        while let Some(chunk) = self.body.next().await {
            extend_bounded(&mut bytes, &chunk?, max_bytes, Error::ByteLimit)?;
        }
        check_deadline(self.deadline)?;
        serde_json::from_slice(&bytes).map_err(|_| Error::Format)
    }

    /// Whitespace-only JSONL lines are skipped and don't count toward max_records.
    pub fn into_jsonl(mut self) -> DocumentStream<serde_json::Value> {
        Box::pin(async_stream::try_stream! {
            self.success()?;
            let mut record = Vec::new();
            let mut rows = 0;
            while let Some(chunk) = self.body.next().await {
                let chunk = chunk?;
                for &byte in chunk.iter() {
                    check_deadline(self.deadline)?;
                    if byte == b'\n' {
                        if !record.iter().all(u8::is_ascii_whitespace) {
                            rows += 1;
                            if rows > self.options.max_records { Err(Error::RowLimit)?; }
                            yield serde_json::from_slice(&record).map_err(|_| Error::Format)?;
                        }
                        record.clear();
                    } else { extend_bounded(&mut record, &[byte], self.options.max_record_bytes, Error::RecordLimit)?; }
                }
            }
            if !record.iter().all(u8::is_ascii_whitespace) {
                check_deadline(self.deadline)?;
                if rows >= self.options.max_records { Err(Error::RowLimit)?; }
                yield serde_json::from_slice(&record).map_err(|_| Error::Format)?;
            }
        })
    }

    /// RFC-style quoted TSV. Blank lines are ignored by csv-core. UTF-8 required.
    /// Set `consistent_fields` to require the first row's field count thereafter.
    pub fn into_tsv(mut self, consistent_fields: bool) -> DocumentStream<Vec<String>> {
        Box::pin(async_stream::try_stream! {
            self.success()?;
            let mut parser = csv_core::ReaderBuilder::new().delimiter(b'\t').build();
            let mut field = Vec::new();
            let mut fields = Vec::new();
            let mut raw_bytes = 0usize;
            let mut materialized = 0usize;
            let mut rows = 0u64;
            let mut expected = None;
            let mut output = [0u8; 4096];
            loop {
                let chunk = self.body.next().await.transpose()?;
                let eof = chunk.is_none();
                let mut input = chunk.as_deref().unwrap_or_default();
                loop {
                    check_deadline(self.deadline)?;
                    let (result, used, produced) = parser.read_field(input, &mut output);
                    raw_bytes = raw_bytes.checked_add(used).ok_or(Error::RecordLimit)?;
                    if raw_bytes > self.options.max_record_bytes { Err(Error::RecordLimit)?; }
                    extend_bounded(&mut field, &output[..produced], self.options.max_record_bytes.saturating_sub(materialized).saturating_sub(std::mem::size_of::<String>()), Error::RecordLimit)?;
                    input = &input[used..];
                    match result {
                        csv_core::ReadFieldResult::Field { record_end } => {
                            materialized = materialized.checked_add(field.capacity()).and_then(|n| n.checked_add(std::mem::size_of::<String>())).ok_or(Error::RecordLimit)?;
                            if materialized > self.options.max_record_bytes { Err(Error::RecordLimit)?; }
                            fields.reserve_exact(1);
                            fields.push(String::from_utf8(std::mem::take(&mut field)).map_err(|_| Error::Format)?);
                            if record_end {
                                rows += 1;
                                if rows > self.options.max_records { Err(Error::RowLimit)?; }
                                if consistent_fields && expected.is_some_and(|count| count != fields.len()) { Err(Error::Format)?; }
                                expected = Some(fields.len());
                                yield std::mem::take(&mut fields);
                                raw_bytes = 0; materialized = 0;
                            }
                        }
                        csv_core::ReadFieldResult::End => break,
                        csv_core::ReadFieldResult::InputEmpty => break,
                        csv_core::ReadFieldResult::OutputFull => {}
                    }
                    if input.is_empty() && !eof { break; }
                }
                if eof { break; }
            }
        })
    }
}

/// Upload replies are always bounded raw bytes, including non-success statuses.
pub struct UploadResponse {
    pub status: u16,
    pub headers: HeaderMap,
    pub body: Vec<u8>,
    pub body_truncated: bool,
}
impl fmt::Debug for UploadResponse {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("UploadResponse")
            .field("status", &self.status)
            .finish_non_exhaustive()
    }
}

impl DocumentClient {
    pub async fn download(&self, url: &str, options: TransferOptions) -> Result<Download, Error> {
        let deadline = options.deadline()?;
        let url = signed_url(url)?;
        let response = timeout_at(deadline, self.http.get(url).timeout(options.timeout).send())
            .await
            .map_err(|_| Error::Timeout)?
            .map_err(transport)?;
        let status = response.status().as_u16();
        let headers = response.headers().clone();
        if !(200..300).contains(&status) {
            let (body, truncated) =
                bounded_response(response, deadline, options.max_response_bytes).await?;
            let body = Bytes::from(body);
            return Ok(Download {
                status,
                headers,
                body: Box::pin(futures_util::stream::once(std::future::ready(Ok(
                    body.clone()
                )))),
                error_body: Some(body),
                error_body_truncated: truncated,
                options,
                deadline,
            });
        }
        let gzip = encoding(&headers, options.compression)?;
        let source = response
            .bytes_stream()
            .map_err(|error| io::Error::other(transport(error)));
        let reader = StreamReader::new(source);
        let reader: Pin<Box<dyn AsyncRead + Send>> = if gzip {
            Box::pin(GzipDecoder::new(BufReader::new(reader)))
        } else {
            Box::pin(reader)
        };
        let body = read_chunks(reader, deadline, options.max_bytes, gzip);
        Ok(Download {
            status,
            headers,
            body,
            error_body: None,
            error_body_truncated: false,
            options,
            deadline,
        })
    }

    /// PUT a caller-owned byte stream. Caller errors are discarded, never chained.
    pub async fn upload<S, E>(
        &self,
        url: &str,
        source: S,
        options: UploadOptions,
    ) -> Result<UploadResponse, Error>
    where
        S: Stream<Item = Result<Bytes, E>> + Send + 'static,
        E: Send + 'static,
    {
        let deadline = options.transfer.deadline()?;
        let url = signed_url(url)?;
        let headers = upload_headers(&options)?;
        if options
            .content_length
            .is_some_and(|length| length > options.transfer.max_bytes)
        {
            return Err(Error::ByteLimit);
        }
        let mut source = Box::pin(source);
        // A zero Content-Length may prevent HTTP from polling the body at all.
        if options.content_length == Some(0) {
            while let Some(chunk) = timeout_at(deadline, source.next())
                .await
                .map_err(|_| Error::Timeout)?
            {
                let chunk = chunk.map_err(|_| Error::UploadSource)?;
                if !chunk.is_empty() {
                    return Err(Error::LengthMismatch);
                }
            }
        }
        let count = Arc::new(AtomicU64::new(0));
        let failure = Arc::new(AtomicU8::new(0));
        let sent = count.clone();
        let failed = failure.clone();
        let length = options.content_length;
        let max_bytes = options.transfer.max_bytes;
        let body = async_stream::stream! {
            loop {
                let next = match timeout_at(deadline, source.next()).await {
                    Ok(next) => next,
                    Err(_) => { failed.store(4, Ordering::SeqCst); yield Err(Error::Timeout); break; }
                };
                match next {
                    Some(Ok(chunk)) => {
                        let previous = sent.load(Ordering::SeqCst);
                        let Some(total) = previous.checked_add(chunk.len() as u64) else { failed.store(2, Ordering::SeqCst); yield Err(Error::ByteLimit); break; };
                        if total > max_bytes { failed.store(2, Ordering::SeqCst); yield Err(Error::ByteLimit); break; }
                        if length.is_some_and(|length| total > length) { failed.store(3, Ordering::SeqCst); yield Err(Error::LengthMismatch); break; }
                        // Don't let HTTP stop polling at Content-Length before
                        // checking the source's final EOF. Hold only this chunk.
                        if length == Some(total) {
                            let final_error = loop {
                                match timeout_at(deadline, source.next()).await {
                                    Err(_) => break Some((4, Error::Timeout)),
                                    Ok(Some(Err(_))) => break Some((1, Error::UploadSource)),
                                    Ok(Some(Ok(extra))) if !extra.is_empty() => break Some((3, Error::LengthMismatch)),
                                    Ok(Some(Ok(_))) => {},
                                    Ok(None) => break None,
                                }
                            };
                            if let Some((code, error)) = final_error { failed.store(code, Ordering::SeqCst); yield Err(error); break; }
                            sent.store(total, Ordering::SeqCst);
                            yield Ok(chunk);
                            break;
                        }
                        sent.store(total, Ordering::SeqCst);
                        yield Ok(chunk);
                    }
                    Some(Err(_)) => { failed.store(1, Ordering::SeqCst); yield Err(Error::UploadSource); break; }
                    None => {
                        if length.is_some_and(|length| sent.load(Ordering::SeqCst) != length) { failed.store(3, Ordering::SeqCst); yield Err(Error::LengthMismatch); }
                        break;
                    }
                }
            }
        };
        let mut request = self
            .http
            .put(url)
            .headers(headers)
            .timeout(options.transfer.timeout)
            .body(reqwest::Body::wrap_stream(body));
        if let Some(length) = options.content_length {
            request = request.header(CONTENT_LENGTH, length);
        }
        let result = timeout_at(deadline, request.send())
            .await
            .map_err(|_| Error::Timeout)?;
        let failure = match failure.load(Ordering::SeqCst) {
            1 => Some(Error::UploadSource),
            2 => Some(Error::ByteLimit),
            3 => Some(Error::LengthMismatch),
            4 => Some(Error::Timeout),
            _ => None,
        };
        if let Some(error) = failure {
            return Err(error);
        }
        let response = result.map_err(transport)?;
        if length.is_some_and(|length| count.load(Ordering::SeqCst) != length) {
            return Err(Error::LengthMismatch);
        }
        let status = response.status().as_u16();
        let headers = response.headers().clone();
        let (body, body_truncated) =
            bounded_response(response, deadline, options.transfer.max_response_bytes).await?;
        Ok(UploadResponse {
            status,
            headers,
            body,
            body_truncated,
        })
    }
}

fn signed_url(text: &str) -> Result<Url, Error> {
    if text
        .chars()
        .any(|c| c.is_whitespace() || c.is_control() || matches!(c, '\\' | '#'))
    {
        return Err(Error::InvalidUrl);
    }
    let (_, rest) = text.split_once("://").ok_or(Error::InvalidUrl)?;
    if rest
        .split(['/', '?'])
        .next()
        .is_none_or(|authority| authority.is_empty() || authority.contains('@'))
    {
        return Err(Error::InvalidUrl);
    }
    for (index, &byte) in text.as_bytes().iter().enumerate() {
        if byte == b'%'
            && !text
                .as_bytes()
                .get(index + 1..index + 3)
                .is_some_and(|hex| hex.iter().all(u8::is_ascii_hexdigit))
        {
            return Err(Error::InvalidUrl);
        }
    }
    let url = Url::parse(text).map_err(|_| Error::InvalidUrl)?;
    let loopback = url.host_str().is_some_and(|host| {
        host == "localhost"
            || host
                .trim_matches(['[', ']'])
                .parse::<std::net::IpAddr>()
                .is_ok_and(|ip| ip.is_loopback())
    });
    if url.host_str().is_none()
        || !url.username().is_empty()
        || url.password().is_some()
        || url.fragment().is_some()
        || !(url.scheme() == "https" || url.scheme() == "http" && loopback)
    {
        return Err(Error::InvalidUrl);
    }
    Ok(url)
}
fn encoding(headers: &HeaderMap, compression: Compression) -> Result<bool, Error> {
    let mut values = headers.get_all(CONTENT_ENCODING).iter();
    let encoding = values
        .next()
        .map(|v| v.to_str().map_err(|_| Error::UnsupportedEncoding))
        .transpose()?;
    if values.next().is_some() {
        return Err(Error::UnsupportedEncoding);
    }
    let gzip = match encoding.map(str::trim) {
        None => false,
        Some(value) if value.eq_ignore_ascii_case("identity") => false,
        Some(value) if value.eq_ignore_ascii_case("gzip") => true,
        _ => return Err(Error::UnsupportedEncoding),
    };
    Ok(compression == Compression::Gzip || compression == Compression::Auto && gzip)
}
fn transport(error: reqwest::Error) -> Error {
    if error.is_timeout() {
        Error::Timeout
    } else {
        Error::Transport
    }
}
fn check_deadline(deadline: Instant) -> Result<(), Error> {
    if Instant::now() >= deadline {
        Err(Error::Timeout)
    } else {
        Ok(())
    }
}
fn read_chunks(
    mut reader: Pin<Box<dyn AsyncRead + Send>>,
    deadline: Instant,
    ceiling: u64,
    gzip: bool,
) -> DocumentStream<Bytes> {
    Box::pin(async_stream::try_stream! {
        let mut total = 0u64;
        let mut buffer = [0u8; 64 << 10];
        loop {
            check_deadline(deadline)?;
            // Read at most remaining + 1, detecting overflow without allocating it.
            let available = (ceiling.saturating_sub(total)).saturating_add(1).min(buffer.len() as u64) as usize;
            let result = timeout_at(deadline, reader.read(&mut buffer[..available])).await.map_err(|_| Error::Timeout)?;
            let read = result.map_err(|error| {
                error.get_ref().and_then(|inner| inner.downcast_ref::<Error>()).copied().unwrap_or(if gzip { Error::Compression } else { Error::Transport })
            })?;
            check_deadline(deadline)?;
            if read == 0 { break; }
            total += read as u64;
            if total > ceiling { Err(Error::ByteLimit)?; }
            yield Bytes::copy_from_slice(&buffer[..read]);
        }
    })
}
async fn bounded_response(
    response: reqwest::Response,
    deadline: Instant,
    ceiling: usize,
) -> Result<(Vec<u8>, bool), Error> {
    let mut stream = response.bytes_stream();
    let mut body = Vec::new();
    loop {
        check_deadline(deadline)?;
        let chunk = timeout_at(deadline, stream.next())
            .await
            .map_err(|_| Error::Timeout)?
            .transpose()
            .map_err(transport)?;
        let Some(chunk) = chunk else {
            return Ok((body, false));
        };
        let remaining = ceiling - body.len();
        extend_bounded(
            &mut body,
            &chunk[..chunk.len().min(remaining)],
            ceiling,
            Error::ByteLimit,
        )?;
        if chunk.len() > remaining {
            return Ok((body, true));
        }
    }
}
fn extend_bounded(
    bytes: &mut Vec<u8>,
    more: &[u8],
    ceiling: usize,
    error: Error,
) -> Result<(), Error> {
    let length = bytes.len().checked_add(more.len()).ok_or(error)?;
    if length > ceiling {
        return Err(error);
    }
    if length > bytes.capacity() {
        let capacity = bytes
            .capacity()
            .saturating_mul(2)
            .max(64)
            .max(length)
            .min(ceiling);
        bytes.reserve_exact(capacity - bytes.len());
    }
    bytes.extend_from_slice(more);
    Ok(())
}
fn upload_headers(options: &UploadOptions) -> Result<HeaderMap, Error> {
    if options.content_type.is_empty() {
        return Err(Error::InvalidHeader);
    }
    let mut headers = HeaderMap::new();
    headers.insert(
        CONTENT_TYPE,
        HeaderValue::from_str(&options.content_type).map_err(|_| Error::InvalidHeader)?,
    );
    for (name, value) in &options.headers {
        let name = HeaderName::from_bytes(name.as_bytes()).map_err(|_| Error::InvalidHeader)?;
        if matches!(
            name.as_str(),
            "authorization"
                | "proxy-authorization"
                | "x-amz-access-token"
                | "content-length"
                | "transfer-encoding"
                | "host"
                | "content-type"
                | "connection"
                | "trailer"
                | "te"
                | "upgrade"
                | "expect"
        ) {
            return Err(Error::InvalidHeader);
        }
        headers.append(
            name,
            HeaderValue::from_str(value).map_err(|_| Error::InvalidHeader)?,
        );
    }
    Ok(headers)
}
