//! Signed document transfers. No API credentials, retries, or redirects. A status
//! outside 2xx is an error that keeps the reply.
//!
//! Download bodies are streamed, including incremental GZIP decoding. JSONL skips
//! whitespace-only lines; TSV uses the csv-core grammar with tab delimiters.
//! TSV text is decoded from the `Content-Type` charset (or a caller override) to UTF-8.
//! The record limit bounds raw record buffers and TSV materialized field storage.
//! Whole JSON decoding is explicitly buffered and requires its own byte limit.
//! Synchronous parsing checks deadline expiry after completion; it cannot preempt
//! CPU work. GZIP consumes every member and validates trailing input.

use crate::{Pool, intercept, url};
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

/// The chunks, records or rows of a document, as they arrive.
pub type DocumentStream<T> = Pin<Box<dyn Stream<Item = Result<T, Error>> + Send + 'static>>;

/// Errors never retain caller errors, URLs or document contents. A rejection keeps
/// the reply of the signed URL.
#[derive(Clone, Debug, PartialEq, Eq)]
#[non_exhaustive]
pub enum Error {
    /// An option was refused before any request: a timeout no deadline can be set by,
    /// or a limit of zero.
    InvalidConfig,
    /// The URL isn't HTTPS, or HTTP on a loopback host, or isn't percent-encoded.
    InvalidUrl,
    /// The content type or a header of an upload can't be sent as a header.
    InvalidHeader,
    /// The `Content-Encoding` of a download is something other than one `gzip`.
    UnsupportedEncoding,
    /// The charset of a TSV document, or the one the caller named, isn't known.
    UnsupportedCharset,
    /// The transfer ran past its timeout.
    Timeout,
    /// The request couldn't be sent or the body couldn't be read.
    Transport,
    /// The GZIP data is invalid or ends early.
    Compression,
    /// The document is larger than `max_bytes`.
    ByteLimit,
    /// A record or a row is larger than `max_record_bytes`.
    RecordLimit,
    /// The content isn't valid JSON, or text in its charset.
    Format,
    /// The signed URL answered outside 2xx.
    Rejected(Box<Rejection>),
    /// The source of an upload returned an error.
    UploadSource,
    /// The source of an upload gave more or fewer bytes than `content_length`.
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
            Self::Format => "invalid document format",
            Self::Rejected(_) => "document response was not successful",
            Self::UploadSource => "document upload source failed",
            Self::LengthMismatch => "document upload length mismatch",
        })
    }
}
impl std::error::Error for Error {}

/// What a signed URL answered outside 2xx. The body is raw and cut at
/// [`MAX_RESPONSE_BYTES`]. Debug shows the status only.
#[derive(Clone, PartialEq, Eq)]
pub struct Rejection {
    /// The HTTP status of the reply.
    pub status: u16,
    /// The headers of the reply.
    pub headers: HeaderMap,
    /// The start of the body, as it arrived.
    pub body: Vec<u8>,
}
impl fmt::Debug for Rejection {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Rejection")
            .field("status", &self.status)
            .finish_non_exhaustive()
    }
}

/// How a download is decompressed.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
#[non_exhaustive]
pub enum Compression {
    /// Decode a single gzip Content-Encoding. Supply Gzip for SP-API metadata.
    #[default]
    Auto,
    /// GZIP metadata. Also a gzip header means the same single layer.
    Gzip,
}
/// The timeout and limits of a transfer. The default allows 30 seconds, any size, and
/// 1 MiB a record.
#[derive(Clone, Debug)]
pub struct TransferOptions {
    /// One deadline for the whole transfer, the body included.
    pub timeout: Duration,
    /// How a download is decompressed.
    pub compression: Compression,
    /// Ceiling on decompressed bytes, independently of Content-Length. There is none
    /// unless the caller sets one.
    pub max_bytes: u64,
    /// Ceiling on one JSON Lines record or one TSV row.
    pub max_record_bytes: usize,
}
/// How much is kept of the body of an upload reply or of a rejection.
pub const MAX_RESPONSE_BYTES: usize = 64 << 10;
impl Default for TransferOptions {
    fn default() -> Self {
        Self {
            timeout: Duration::from_secs(30),
            compression: Compression::Auto,
            max_bytes: u64::MAX,
            max_record_bytes: 1 << 20,
        }
    }
}
impl TransferOptions {
    pub(crate) fn deadline(&self) -> Result<Instant, Error> {
        if self.max_bytes == 0 || self.max_record_bytes == 0 {
            return Err(Error::InvalidConfig);
        }
        crate::deadline(self.timeout).ok_or(Error::InvalidConfig)
    }
}

/// Debug hides signed header values and the content type.
#[derive(Clone)]
pub struct UploadOptions {
    /// The timeout of the upload, and `max_bytes` as a ceiling on what is sent.
    pub transfer: TransferOptions,
    /// The `Content-Type` to send. A signed URL is signed for one.
    pub content_type: String,
    /// More headers to send, when the URL was signed with them.
    pub headers: Vec<(String, String)>,
    /// The length of the source. With one the upload sends `Content-Length`, and a
    /// source of another length fails. Without one the body goes out chunked.
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

/// Downloads from and uploads to signed URLs. [`Client::documents`](crate::Client::documents)
/// builds it on the client's pool, without its access token.
#[derive(Clone)]
pub struct DocumentClient {
    pool: Pool,
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
            pool: self.pool.clone(),
        }
    }
}

/// A document whose signed URL answered inside 2xx.
pub struct Download {
    status: u16,
    headers: HeaderMap,
    body: DocumentStream<Bytes>,
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
    /// The HTTP status of the reply, inside 2xx.
    pub fn status(&self) -> u16 {
        self.status
    }
    /// The headers of the reply.
    pub fn headers(&self) -> &HeaderMap {
        &self.headers
    }
    /// The `charset` parameter of the response `Content-Type`, as sent.
    pub fn charset(&self) -> Option<String> {
        header_charset(&self.headers)
    }
    /// The bytes of the document, decompressed, as they arrive.
    pub fn into_chunks(self) -> DocumentStream<Bytes> {
        self.body
    }

    /// Buffered whole JSON, distinct from streaming JSONL. `max_bytes` is required.
    pub async fn json(self, max_bytes: usize) -> Result<serde_json::Value, Error> {
        self.whole(max_bytes, |json| value(json)).await
    }

    /// Like `json`, with the document as it is: the same limit and errors, valid UTF-8
    /// and valid JSON, and the keys in their own order.
    pub async fn json_text(self, max_bytes: usize) -> Result<String, Error> {
        self.whole(max_bytes, text).await
    }

    async fn whole<T>(
        mut self,
        max_bytes: usize,
        read: fn(&mut Vec<u8>) -> Result<T, Error>,
    ) -> Result<T, Error> {
        if max_bytes == 0 {
            return Err(Error::InvalidConfig);
        }
        let mut bytes = Vec::new();
        while let Some(chunk) = self.body.next().await {
            extend_bounded(&mut bytes, &chunk?, max_bytes, Error::ByteLimit)?;
        }
        check_deadline(self.deadline)?;
        let result = read(&mut bytes);
        check_deadline(self.deadline)?;
        result
    }

    /// Whitespace-only JSONL lines are skipped.
    pub fn into_jsonl(self) -> DocumentStream<serde_json::Value> {
        self.jsonl(|record| value(record))
    }

    /// Like `into_jsonl`, with each record as the document has it: the same limits and
    /// errors, valid UTF-8 and valid JSON, and the keys in their own order.
    pub fn into_jsonl_records(self) -> DocumentStream<String> {
        self.jsonl(text)
    }

    fn jsonl<T: Send + 'static>(
        mut self,
        row: fn(&mut Vec<u8>) -> Result<T, Error>,
    ) -> DocumentStream<T> {
        Box::pin(async_stream::try_stream! {
            let mut record = Vec::new();
            while let Some(chunk) = self.body.next().await {
                let chunk = chunk?;
                // The deadline is checked per chunk and per record, not per byte.
                check_deadline(self.deadline)?;
                let mut yielded = false;
                let mut rest = &chunk[..];
                while let Some(end) = rest.iter().position(|&byte| byte == b'\n') {
                    extend_bounded(&mut record, &rest[..end], self.options.max_record_bytes, Error::RecordLimit)?;
                    rest = &rest[end + 1..];
                    if !record.iter().all(u8::is_ascii_whitespace) {
                        check_deadline(self.deadline)?;
                        let result = row(&mut record);
                        check_deadline(self.deadline)?;
                        yield result?;
                        yielded = true;
                    }
                    record.clear();
                }
                extend_bounded(&mut record, rest, self.options.max_record_bytes, Error::RecordLimit)?;
                // Blank lines yield nothing, so a run of them would otherwise be framed in
                // one poll for as long as the body stays ready.
                if !yielded { give_way().await; }
            }
            if !record.iter().all(u8::is_ascii_whitespace) {
                check_deadline(self.deadline)?;
                let result = row(&mut record);
                check_deadline(self.deadline)?;
                yield result?;
            }
        })
    }

    /// RFC-style quoted TSV. Blank lines are ignored by csv-core. Text is decoded
    /// with the `Content-Type` charset, UTF-8 when there is none. Rows are UTF-8.
    pub fn into_tsv(self) -> DocumentStream<Vec<String>> {
        let charset = self.charset();
        self.tsv(charset)
    }

    /// Like `into_tsv`, with `charset` taking precedence over the header.
    pub fn into_tsv_with_charset(self, charset: &str) -> DocumentStream<Vec<String>> {
        self.tsv(Some(charset.to_owned()))
    }

    fn tsv(mut self, charset: Option<String>) -> DocumentStream<Vec<String>> {
        Box::pin(async_stream::try_stream! {
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
            let mut output = [0u8; 4096];
            loop {
                let chunk = self.body.next().await.transpose()?;
                let eof = chunk.is_none();
                decode_into(&mut decoder, chunk.as_deref().unwrap_or_default(), eof, &mut text)?;
                // csv-core reads empty input as EOF; a split character decodes to none.
                if text.is_empty() && !eof { give_way().await; continue; }
                let mut yielded = false;
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
                                let row = std::mem::take(&mut fields);
                                check_deadline(self.deadline)?;
                                yield row;
                                yielded = true;
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
                // csv-core skips blank lines without a row, so a run of them would otherwise
                // be framed in one poll for as long as the body stays ready.
                if !yielded { give_way().await; }
            }
        })
    }
}

fn value(json: &[u8]) -> Result<serde_json::Value, Error> {
    serde_json::from_slice(json).map_err(|_| Error::Format)
}
/// The JSON as the document has it, once it reads as a value.
fn text(json: &mut Vec<u8>) -> Result<String, Error> {
    serde_json::from_slice::<Checked>(json).map_err(|_| Error::Format)?;
    String::from_utf8(std::mem::take(json)).map_err(|_| Error::Format)
}
/// Reads a JSON value as `serde_json::Value` does, with the same limits, and keeps none
/// of it.
struct Checked;
impl<'de> serde::Deserialize<'de> for Checked {
    fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
        deserializer.deserialize_any(Checked)
    }
}
impl<'de> serde::de::Visitor<'de> for Checked {
    type Value = Self;
    fn expecting(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("a JSON value")
    }
    fn visit_bool<E>(self, _: bool) -> Result<Self, E> {
        Ok(self)
    }
    fn visit_i64<E>(self, _: i64) -> Result<Self, E> {
        Ok(self)
    }
    fn visit_u64<E>(self, _: u64) -> Result<Self, E> {
        Ok(self)
    }
    fn visit_f64<E>(self, _: f64) -> Result<Self, E> {
        Ok(self)
    }
    fn visit_str<E>(self, _: &str) -> Result<Self, E> {
        Ok(self)
    }
    fn visit_unit<E>(self) -> Result<Self, E> {
        Ok(self)
    }
    fn visit_seq<A: serde::de::SeqAccess<'de>>(self, mut seq: A) -> Result<Self, A::Error> {
        while seq.next_element::<Self>()?.is_some() {}
        Ok(self)
    }
    fn visit_map<A: serde::de::MapAccess<'de>>(self, mut map: A) -> Result<Self, A::Error> {
        while map.next_entry::<Self, Self>()?.is_some() {}
        Ok(self)
    }
}

/// The reply to an upload the signed URL accepted. The body is raw and cut at
/// [`MAX_RESPONSE_BYTES`].
pub struct UploadResponse {
    /// The HTTP status of the reply, inside 2xx.
    pub status: u16,
    /// The headers of the reply.
    pub headers: HeaderMap,
    /// The start of the body, as it arrived.
    pub body: Vec<u8>,
}
impl fmt::Debug for UploadResponse {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("UploadResponse")
            .field("status", &self.status)
            .finish_non_exhaustive()
    }
}

impl DocumentClient {
    /// A status outside 2xx is [`Error::Rejected`].
    pub async fn download(&self, url: &str, options: TransferOptions) -> Result<Download, Error> {
        let deadline = options.deadline()?;
        let url = signed_url(url)?;
        let request = self.pool.http.get(url).timeout(options.timeout);
        if let Some(interceptor) = self.pool.interceptor() {
            let request = request.build().map_err(transport)?;
            let reply = timeout_at(deadline, self.pool.intercepted(interceptor, request))
                .await
                .map_err(|_| Error::Timeout)??;
            let (status, headers, body) = accepted_reply(reply)?;
            let source = futures_util::stream::iter([Ok::<_, io::Error>(Bytes::from(body))]);
            return document(status, headers, source, options, deadline);
        }
        let response = timeout_at(deadline, request.send())
            .await
            .map_err(|_| Error::Timeout)?
            .map_err(transport)?;
        let response = accepted(response, deadline).await?;
        let status = response.status().as_u16();
        let headers = response.headers().clone();
        let source = response
            .bytes_stream()
            .map_err(|error| io::Error::other(transport(error)));
        document(status, headers, source, options, deadline)
    }

    /// PUT a caller-owned byte stream. Caller errors are discarded, never chained.
    /// A status outside 2xx is [`Error::Rejected`].
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
            let fail = |error: Error| -> Result<Bytes, Error> { let _ = failed.set(error.clone()); Err(error) };
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
            .pool
            .http
            .put(url)
            .headers(headers)
            .timeout(options.transfer.timeout);
        if let Some(length) = options.content_length {
            request = request.header(CONTENT_LENGTH, length);
        }
        if let Some(interceptor) = self.pool.interceptor() {
            // An interceptor takes a whole body, so the source is read to its end first,
            // under the checks it gets as a stream.
            let mut whole = Vec::new();
            let mut body = std::pin::pin!(body);
            while let Some(chunk) = body.next().await {
                whole.extend_from_slice(&chunk?);
            }
            let request = request.body(whole).build().map_err(transport)?;
            let reply = timeout_at(deadline, self.pool.intercepted(interceptor, request))
                .await
                .map_err(|_| Error::Timeout)??;
            let (status, headers, mut body) = accepted_reply(reply)?;
            body.truncate(MAX_RESPONSE_BYTES);
            return Ok(UploadResponse {
                status,
                headers,
                body,
            });
        }
        let request = request.body(reqwest::Body::wrap_stream(body));
        let result = timeout_at(deadline, request.send())
            .await
            .map_err(|_| Error::Timeout)?;
        if let Some(error) = failure.get() {
            return Err(error.clone());
        }
        let response = accepted(result.map_err(transport)?, deadline).await?;
        if length.is_some_and(|length| count.load(Ordering::SeqCst) != length) {
            return Err(Error::LengthMismatch);
        }
        let status = response.status().as_u16();
        let headers = response.headers().clone();
        let body = bounded_response(response, deadline).await?;
        Ok(UploadResponse {
            status,
            headers,
            body,
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
    Ok(compression == Compression::Gzip || gzip)
}
fn transport(error: reqwest::Error) -> Error {
    crate::classify(error, Error::Timeout, Error::Transport)
}
/// Returns `Pending` once, after waking its own task, so the current poll ends.
async fn give_way() {
    let mut pending = true;
    std::future::poll_fn(|cx| {
        if std::mem::take(&mut pending) {
            cx.waker().wake_by_ref();
            std::task::Poll::Pending
        } else {
            std::task::Poll::Ready(())
        }
    })
    .await;
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
                error.get_ref().and_then(|inner| inner.downcast_ref::<Error>()).cloned().unwrap_or(if gzip { Error::Compression } else { Error::Transport })
            })?;
            check_deadline(deadline)?;
            if read == 0 { break; }
            total += read as u64;
            if total > ceiling { Err(Error::ByteLimit)?; }
            yield Bytes::copy_from_slice(&buffer[..read]);
        }
    })
}
/// The document of a reply inside 2xx, decompressed as its headers and the options say.
fn document(
    status: u16,
    headers: HeaderMap,
    source: impl Stream<Item = io::Result<Bytes>> + Send + 'static,
    options: TransferOptions,
    deadline: Instant,
) -> Result<Download, Error> {
    let gzip = encoding(&headers, options.compression)?;
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
        options,
        deadline,
    })
}
/// Like `accepted`, for the whole reply an interceptor gave: its status, headers and
/// body when the status is inside 2xx.
fn accepted_reply(reply: crate::Response) -> Result<(u16, HeaderMap, Vec<u8>), Error> {
    let headers = intercept::header_map(&reply.headers);
    let mut body = reply.body;
    if (200..300).contains(&reply.status) {
        return Ok((reply.status, headers, body));
    }
    body.truncate(MAX_RESPONSE_BYTES);
    Err(Error::Rejected(Box::new(Rejection {
        status: reply.status,
        headers,
        body,
    })))
}
/// The response if its status is inside 2xx. Otherwise the rejection.
async fn accepted(
    response: reqwest::Response,
    deadline: Instant,
) -> Result<reqwest::Response, Error> {
    if response.status().is_success() {
        return Ok(response);
    }
    let status = response.status().as_u16();
    let headers = response.headers().clone();
    let body = bounded_response(response, deadline).await?;
    Err(Error::Rejected(Box::new(Rejection {
        status,
        headers,
        body,
    })))
}
/// The first `MAX_RESPONSE_BYTES` of a body, raw.
async fn bounded_response(
    response: reqwest::Response,
    deadline: Instant,
) -> Result<Vec<u8>, Error> {
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
            return Ok(body);
        };
        let remaining = MAX_RESPONSE_BYTES - body.len();
        extend_bounded(
            &mut body,
            &chunk[..chunk.len().min(remaining)],
            MAX_RESPONSE_BYTES,
            Error::ByteLimit,
        )?;
        if chunk.len() > remaining {
            return Ok(body);
        }
    }
}
fn extend_bounded(
    bytes: &mut Vec<u8>,
    more: &[u8],
    ceiling: usize,
    error: Error,
) -> Result<(), Error> {
    let length = bytes.len().checked_add(more.len());
    let Some(length) = length.filter(|length| *length <= ceiling) else {
        return Err(error);
    };
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

#[cfg(test)]
mod tests {
    use super::*;
    use futures_util::FutureExt;

    #[tokio::test]
    async fn a_jsonl_chunk_without_a_record_ends_the_poll() {
        let download = Download {
            status: 200,
            headers: HeaderMap::new(),
            body: Box::pin(futures_util::stream::iter([
                Ok(Bytes::from_static(b"\n \n\t\n")),
                Ok(Bytes::from_static(b"{\"a\":1}\n")),
            ])),
            options: TransferOptions::default(),
            deadline: Instant::now() + Duration::from_secs(30),
        };
        let mut rows = download.into_jsonl();
        assert!(rows.next().now_or_never().is_none());
        assert_eq!(
            rows.collect::<Vec<_>>().await,
            [Ok(serde_json::json!({"a": 1}))]
        );
    }

    #[tokio::test]
    async fn a_tsv_chunk_without_a_row_ends_the_poll() {
        let download = Download {
            status: 200,
            headers: HeaderMap::new(),
            body: Box::pin(futures_util::stream::iter([
                Ok(Bytes::from_static(b"\n\n\n")),
                Ok(Bytes::from_static(b"a\tb\n")),
            ])),
            options: TransferOptions::default(),
            deadline: Instant::now() + Duration::from_secs(30),
        };
        let mut rows = download.into_tsv();
        assert!(rows.next().now_or_never().is_none());
        assert_eq!(
            rows.collect::<Vec<_>>().await,
            [Ok(vec!["a".to_owned(), "b".to_owned()])]
        );
    }
}
