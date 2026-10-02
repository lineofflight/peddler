//! Signed document transfers. No API credentials, retries, or redirects.
//!
//! Download bodies are streamed, including incremental GZIP decoding. JSONL skips
//! whitespace-only lines; TSV uses the csv-core grammar with tab delimiters.
//! TSV text is decoded from the `Content-Type` charset (or a caller override) to UTF-8.
//! Record limits bound raw record buffers and TSV materialized field storage.
//! Whole JSON decoding is explicitly buffered and requires its own byte limit.
//! Synchronous parsing checks deadline expiry after completion; it cannot preempt
//! CPU work. GZIP consumes every member and validates trailing input.

use crate::url;
use async_compression::tokio::bufread::GzipDecoder;
use bytes::Bytes;
use encoding_rs::{Decoder, DecoderResult, Encoding};
use futures_util::{Stream, StreamExt, TryStreamExt};
use reqwest::{
    Url,
    header::{CONTENT_ENCODING, CONTENT_LENGTH, CONTENT_TYPE, HeaderMap, HeaderName, HeaderValue},
};
use std::{
    fmt, io,
    pin::Pin,
    sync::{
        Arc, OnceLock,
        atomic::{AtomicU64, Ordering},
    },
    time::Duration,
};
use tokio::{
    io::{AsyncRead, AsyncReadExt, BufReader},
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
    UnsupportedCharset,
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
}
impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(match self {
            Self::InvalidConfig => "invalid document configuration",
            Self::InvalidUrl => "invalid document URL",
            Self::InvalidHeader => "invalid document header",
            Self::UnsupportedEncoding => "unsupported document encoding",
            Self::UnsupportedCharset => "unsupported document charset",
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
    pub(crate) fn deadline(&self) -> Result<Instant, Error> {
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
    /// The `charset` parameter of the response `Content-Type`, as sent.
    pub fn charset(&self) -> Option<String> {
        header_charset(&self.headers)
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
        let result = serde_json::from_slice(&bytes).map_err(|_| Error::Format);
        check_deadline(self.deadline)?;
        result
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
                            let result = serde_json::from_slice(&record).map_err(|_| Error::Format);
                            check_deadline(self.deadline)?;
                            yield result?;
                        }
                        record.clear();
                    } else { extend_bounded(&mut record, &[byte], self.options.max_record_bytes, Error::RecordLimit)?; }
                }
            }
            if !record.iter().all(u8::is_ascii_whitespace) {
                check_deadline(self.deadline)?;
                if rows >= self.options.max_records { Err(Error::RowLimit)?; }
                let result = serde_json::from_slice(&record).map_err(|_| Error::Format);
                check_deadline(self.deadline)?;
                yield result?;
            }
        })
    }

    /// RFC-style quoted TSV. Blank lines are ignored by csv-core. Text is decoded
    /// with the `Content-Type` charset, UTF-8 when there is none. Rows are UTF-8.
    /// Set `consistent_fields` to require the first row's field count thereafter.
    pub fn into_tsv(self, consistent_fields: bool) -> DocumentStream<Vec<String>> {
        let charset = self.charset();
        self.tsv(consistent_fields, charset)
    }

    /// Like `into_tsv`, with `charset` taking precedence over the header.
    pub fn into_tsv_with_charset(
        self,
        consistent_fields: bool,
        charset: &str,
    ) -> DocumentStream<Vec<String>> {
        self.tsv(consistent_fields, Some(charset.to_owned()))
    }

    fn tsv(
        mut self,
        consistent_fields: bool,
        charset: Option<String>,
    ) -> DocumentStream<Vec<String>> {
        Box::pin(async_stream::try_stream! {
            self.success()?;
            let mut decoder = match charset.as_deref() {
                Some(label) => resolve_charset(label)?.new_decoder_with_bom_removal(),
                None => encoding_rs::UTF_8.new_decoder_with_bom_removal(),
            };
            let mut text = Vec::new();
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
                decode_into(&mut decoder, chunk.as_deref().unwrap_or_default(), eof, &mut text)?;
                // csv-core reads empty input as EOF; a split character decodes to none.
                if text.is_empty() && !eof { continue; }
                let mut input = &text[..];
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
                                let row = std::mem::take(&mut fields);
                                check_deadline(self.deadline)?;
                                yield row;
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
            let mut decoder = GzipDecoder::new(BufReader::new(reader));
            decoder.multiple_members(true);
            Box::pin(decoder)
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
        // HTTP reports a failed body only as a transport error, so the body keeps its own.
        let failure = Arc::new(OnceLock::new());
        let sent = count.clone();
        let failed = failure.clone();
        let length = options.content_length;
        let max_bytes = options.transfer.max_bytes;
        let body = async_stream::stream! {
            let fail = |error| -> Result<Bytes, Error> { let _ = failed.set(error); Err(error) };
            loop {
                let next = match timeout_at(deadline, source.next()).await {
                    Ok(next) => next,
                    Err(_) => { yield fail(Error::Timeout); break; }
                };
                match next {
                    Some(Ok(chunk)) => {
                        let previous = sent.load(Ordering::SeqCst);
                        let Some(total) = previous.checked_add(chunk.len() as u64) else { yield fail(Error::ByteLimit); break; };
                        if total > max_bytes { yield fail(Error::ByteLimit); break; }
                        if length.is_some_and(|length| total > length) { yield fail(Error::LengthMismatch); break; }
                        // Don't let HTTP stop polling at Content-Length before
                        // checking the source's final EOF. Hold only this chunk.
                        if length == Some(total) {
                            let final_error = loop {
                                match timeout_at(deadline, source.next()).await {
                                    Err(_) => break Some(Error::Timeout),
                                    Ok(Some(Err(_))) => break Some(Error::UploadSource),
                                    Ok(Some(Ok(extra))) if !extra.is_empty() => break Some(Error::LengthMismatch),
                                    Ok(Some(Ok(_))) => {},
                                    Ok(None) => break None,
                                }
                            };
                            if let Some(error) = final_error { yield fail(error); break; }
                            sent.store(total, Ordering::SeqCst);
                            yield Ok(chunk);
                            break;
                        }
                        sent.store(total, Ordering::SeqCst);
                        yield Ok(chunk);
                    }
                    Some(Err(_)) => { yield fail(Error::UploadSource); break; }
                    None => {
                        if length.is_some_and(|length| sent.load(Ordering::SeqCst) != length) { yield fail(Error::LengthMismatch); }
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
        if let Some(error) = failure.get() {
            return Err(*error);
        }
        let response = result.map_err(transport)?;
        if response.status().is_success()
            && length.is_some_and(|length| count.load(Ordering::SeqCst) != length)
        {
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

/// Validate a signed URL without retaining it.
pub(crate) fn check_url(text: &str) -> Result<(), Error> {
    signed_url(text).map(|_| ())
}
/// Validate everything about an upload that does not need the source or network,
/// and start its deadline.
pub(crate) fn check_upload(options: &UploadOptions) -> Result<Instant, Error> {
    let deadline = options.transfer.deadline()?;
    upload_headers(options)?;
    Ok(deadline)
}
/// HTTPS, or HTTP to a loopback host, with the query that signs it.
fn signed_url(text: &str) -> Result<Url, Error> {
    url::parse(text, &[])
        .map(|(_, signed)| signed)
        .filter(|signed| {
            signed.scheme() == "https" || signed.scheme() == "http" && url::is_loopback(signed)
        })
        .filter(|_| url::well_escaped(text))
        .ok_or(Error::InvalidUrl)
}
/// Charset labels Amazon uses that the WHATWG table lacks.
const CHARSET_ALIASES: &[(&str, &str)] = &[("cp932", "shift_jis")];

fn header_charset(headers: &HeaderMap) -> Option<String> {
    let value = headers.get(CONTENT_TYPE)?.to_str().ok()?;
    value.split(';').skip(1).find_map(|parameter| {
        let (name, value) = parameter.split_once('=')?;
        name.trim()
            .eq_ignore_ascii_case("charset")
            .then(|| value.trim().trim_matches('"').to_owned())
    })
}
fn resolve_charset(label: &str) -> Result<&'static Encoding, Error> {
    let label = label.trim();
    let label = CHARSET_ALIASES
        .iter()
        .find(|(alias, _)| alias.eq_ignore_ascii_case(label))
        .map_or(label, |(_, target)| target);
    Encoding::for_label(label.as_bytes())
        .filter(|encoding| *encoding != encoding_rs::REPLACEMENT)
        .ok_or(Error::UnsupportedCharset)
}
/// Replace `out` with the UTF-8 for `input`. Invalid input is an error, never U+FFFD.
/// The decoder keeps a character split across calls; `last` flushes it.
fn decode_into(
    decoder: &mut Decoder,
    input: &[u8],
    last: bool,
    out: &mut Vec<u8>,
) -> Result<(), Error> {
    let capacity = decoder
        .max_utf8_buffer_length_without_replacement(input.len())
        .ok_or(Error::Format)?;
    out.clear();
    out.resize(capacity, 0);
    let (result, _, written) = decoder.decode_to_utf8_without_replacement(input, out, last);
    match result {
        DecoderResult::InputEmpty => {
            out.truncate(written);
            Ok(())
        }
        _ => Err(Error::Format),
    }
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
/// The headers of an upload. The declared length is checked after them.
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
    if options
        .content_length
        .is_some_and(|length| length > options.transfer.max_bytes)
    {
        return Err(Error::ByteLimit);
    }
    Ok(headers)
}
