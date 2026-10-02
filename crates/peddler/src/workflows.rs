//! Report, feed and Data Kiosk document lifecycle helpers.
//!
//! Metadata requests use the generated operations, so they carry the client's access
//! token and follow its retry policy. Signed document transfers use the
//! credential-free document client. Each helper takes one explicit total deadline
//! (`TransferOptions::timeout`, `UploadOptions::transfer.timeout` or
//! `WaitOptions::timeout`), measured from the call. Time spent on metadata is
//! deducted before the transfer starts, so the transfer receives the remainder.
//! The deadline also covers reading the downloaded body.
//!
//! No helper retries a mutation or submits a feed. Errors never contain signed
//! URLs, response bodies or tokens; failed metadata responses are available only
//! through [`WorkflowError::response`].

use crate::{
    Client, Error as ClientError, Response, TypedResponse,
    apis::{
        data_kiosk_2023_11_15 as kiosk, feeds_2021_06_30 as feeds, reports_2021_06_30 as reports,
    },
    documents::{self, Compression, Download, TransferOptions, UploadOptions, UploadResponse},
};
use bytes::Bytes;
use futures_util::Stream;
use serde::de::DeserializeOwned;
use std::{fmt, future::Future, time::Duration};
use tokio::time::{Instant, sleep_until, timeout_at};

/// Polling interval and total timeout. Both must be positive.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct WaitOptions {
    pub interval: Duration,
    pub timeout: Duration,
}
impl Default for WaitOptions {
    fn default() -> Self {
        Self {
            interval: Duration::from_secs(5),
            timeout: Duration::from_secs(300),
        }
    }
}

/// A created feed document and the raw reply to its upload. The upload reply may
/// be a non-success status; inspect it. `createFeed` is never called.
#[derive(Debug)]
pub struct FeedDocumentUpload {
    pub document_id: String,
    pub response: UploadResponse,
}

/// A created feed document awaiting its upload. Debug hides the signed URL.
pub struct FeedDocumentTarget {
    client: documents::DocumentClient,
    pub document_id: String,
    url: String,
    content_type: String,
    deadline: Instant,
}
impl fmt::Debug for FeedDocumentTarget {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("FeedDocumentTarget")
            .field("document_id", &self.document_id)
            .finish_non_exhaustive()
    }
}
impl FeedDocumentTarget {
    /// Upload to the signed URL with the Content-Type given at creation, within
    /// the time left of the deadline that began at creation. The source is first
    /// polled here, never before valid metadata exists. Not retried. A non-success
    /// reply is returned as the raw response, not as an error.
    pub async fn upload<S, E>(
        self,
        source: S,
        mut options: UploadOptions,
    ) -> Result<FeedDocumentUpload, WorkflowError>
    where
        S: Stream<Item = Result<Bytes, E>> + Send + 'static,
        E: Send + 'static,
    {
        let Self {
            client,
            document_id,
            url,
            content_type,
            deadline,
        } = self;
        let failed = |error| WorkflowError::Upload {
            document_id: document_id.clone(),
            error,
        };
        options.content_type = content_type;
        options.transfer.timeout =
            remaining(deadline).map_err(|_| failed(documents::Error::Timeout))?;
        let response = client.upload(&url, source, options).await.map_err(failed)?;
        Ok(FeedDocumentUpload {
            document_id,
            response,
        })
    }
}

pub enum WorkflowError {
    /// Invalid identifier, content type, interval, timeout or transfer limits.
    InvalidConfig,
    /// Metadata request failed before an HTTP response.
    Request(ClientError),
    /// Metadata response had an unexpected status. Raw response retained.
    Http(Response),
    /// Metadata was malformed, or its document URL was missing or invalid.
    Metadata,
    /// Processing status was not one this library knows.
    Status,
    /// Metadata names a compression algorithm other than GZIP.
    UnsupportedCompression,
    /// Caller compression contradicts what the metadata declares.
    CompressionConflict,
    Timeout,
    /// Download failed to start.
    Document(documents::Error),
    /// Upload failed after the feed document was created.
    Upload {
        document_id: String,
        error: documents::Error,
    },
}
impl WorkflowError {
    /// The raw metadata response, for [`WorkflowError::Http`].
    pub fn response(&self) -> Option<&Response> {
        match self {
            Self::Http(response) => Some(response),
            _ => None,
        }
    }
    /// The created feed document, once known.
    pub fn document_id(&self) -> Option<&str> {
        match self {
            Self::Upload { document_id, .. } => Some(document_id),
            _ => None,
        }
    }
}
impl fmt::Display for WorkflowError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidConfig => f.write_str("invalid workflow configuration"),
            Self::Request(error) => write!(f, "document metadata request failed: {error}"),
            Self::Http(response) => {
                write!(f, "document metadata returned status {}", response.status)
            }
            Self::Metadata => f.write_str("invalid document metadata"),
            Self::Status => f.write_str("unknown processing status"),
            Self::UnsupportedCompression => f.write_str("unsupported document compression"),
            Self::CompressionConflict => {
                f.write_str("compression conflicts with document metadata")
            }
            Self::Timeout => f.write_str("workflow timed out"),
            Self::Document(error) => write!(f, "{error}"),
            Self::Upload { error, .. } => write!(f, "feed document upload failed: {error}"),
        }
    }
}
impl fmt::Debug for WorkflowError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Request(error) => f.debug_tuple("Request").field(error).finish(),
            Self::Http(response) => f
                .debug_struct("Http")
                .field("status", &response.status)
                .finish_non_exhaustive(),
            Self::Document(error) => f.debug_tuple("Document").field(error).finish(),
            Self::Upload { document_id, error } => f
                .debug_struct("Upload")
                .field("document_id", document_id)
                .field("error", error)
                .finish(),
            Self::InvalidConfig => f.write_str("InvalidConfig"),
            Self::Metadata => f.write_str("Metadata"),
            Self::Status => f.write_str("Status"),
            Self::UnsupportedCompression => f.write_str("UnsupportedCompression"),
            Self::CompressionConflict => f.write_str("CompressionConflict"),
            Self::Timeout => f.write_str("Timeout"),
        }
    }
}
impl std::error::Error for WorkflowError {}

/// Cheap view over a [`Client`], sharing its pool, access token and retry policy.
#[derive(Clone, Debug)]
pub struct Workflows {
    client: Client,
}
impl Client {
    pub fn workflows(&self) -> Workflows {
        Workflows {
            client: self.clone(),
        }
    }
}

/// Where the document's compression is declared.
#[derive(Clone, Copy)]
enum Declared {
    /// Only the HTTP Content-Encoding header (Data Kiosk, or no metadata field).
    Header,
    /// Metadata `compressionAlgorithm` is "GZIP".
    Gzip,
}

fn declared(algorithm: Option<&str>) -> Result<Declared, WorkflowError> {
    match algorithm {
        None => Ok(Declared::Header),
        Some("GZIP") => Ok(Declared::Gzip),
        Some(_) => Err(WorkflowError::UnsupportedCompression),
    }
}
fn resolve(requested: Compression, declared: Declared) -> Result<Compression, WorkflowError> {
    match (declared, requested) {
        (Declared::Gzip, Compression::Auto | Compression::Gzip) => Ok(Compression::Gzip),
        (Declared::Header, Compression::Auto | Compression::None) => Ok(requested),
        _ => Err(WorkflowError::CompressionConflict),
    }
}
fn request_error(error: ClientError) -> WorkflowError {
    match error {
        ClientError::Timeout => WorkflowError::Timeout,
        ClientError::InvalidRequest => WorkflowError::InvalidConfig,
        error => WorkflowError::Request(error),
    }
}
fn document_error(error: documents::Error) -> WorkflowError {
    match error {
        documents::Error::Timeout => WorkflowError::Timeout,
        error => WorkflowError::Document(error),
    }
}
fn id(value: &str) -> Result<String, WorkflowError> {
    if value.is_empty() {
        Err(WorkflowError::InvalidConfig)
    } else {
        Ok(value.to_owned())
    }
}
fn remaining(deadline: Instant) -> Result<Duration, WorkflowError> {
    let left = deadline.saturating_duration_since(Instant::now());
    if left.is_zero() {
        Err(WorkflowError::Timeout)
    } else {
        Ok(left)
    }
}
/// One metadata request under the deadline. The reply must carry exactly `status`
/// and decode. The model comes with the response it was read from.
async fn metadata<T: DeserializeOwned>(
    deadline: Instant,
    status: u16,
    call: impl Future<Output = Result<TypedResponse<T>, ClientError>>,
) -> Result<(T, TypedResponse<T>), WorkflowError> {
    let typed = timeout_at(deadline, call)
        .await
        .map_err(|_| WorkflowError::Timeout)?
        .map_err(request_error)?;
    if typed.raw.status != status {
        return Err(WorkflowError::Http(typed.into_raw()));
    }
    let model = typed.json().map_err(|_| WorkflowError::Metadata)?;
    Ok((model, typed))
}

impl Workflows {
    pub async fn download_report_document(
        &self,
        document_id: &str,
        options: TransferOptions,
    ) -> Result<Download, WorkflowError> {
        let id = id(document_id)?;
        let deadline = Self::start(&options)?;
        let (document, _) = metadata(
            deadline,
            200,
            reports::get_report_document(&self.client, reports::GetReportDocumentParams::new(id)),
        )
        .await?;
        let declared = declared(document.compression_algorithm.as_deref())?;
        self.transfer(deadline, options, &document.url, declared)
            .await
    }

    pub async fn download_feed_document(
        &self,
        document_id: &str,
        options: TransferOptions,
    ) -> Result<Download, WorkflowError> {
        let id = id(document_id)?;
        let deadline = Self::start(&options)?;
        let (document, _) = metadata(
            deadline,
            200,
            feeds::get_feed_document(&self.client, feeds::GetFeedDocumentParams::new(id)),
        )
        .await?;
        let declared = declared(document.compression_algorithm.as_deref())?;
        self.transfer(deadline, options, &document.url, declared)
            .await
    }

    /// Data Kiosk documents declare compression only through Content-Encoding.
    pub async fn download_query_document(
        &self,
        document_id: &str,
        options: TransferOptions,
    ) -> Result<Download, WorkflowError> {
        let id = id(document_id)?;
        let deadline = Self::start(&options)?;
        resolve(options.compression, Declared::Header)?;
        let (document, _) = metadata(
            deadline,
            200,
            kiosk::get_document(&self.client, kiosk::GetDocumentParams::new(id)),
        )
        .await?;
        self.transfer(deadline, options, &document.document_url, Declared::Header)
            .await
    }

    /// Poll `getReport` until DONE, CANCELLED or FATAL and return that response.
    pub async fn wait_for_report(
        &self,
        report_id: &str,
        options: WaitOptions,
    ) -> Result<TypedResponse<reports::models::Report>, WorkflowError> {
        let id = id(report_id)?;
        poll(
            options,
            |report: &reports::models::Report| report.processing_status.clone(),
            || reports::get_report(&self.client, reports::GetReportParams::new(id.clone())),
        )
        .await
    }

    /// Poll `getFeed` until DONE, CANCELLED or FATAL and return that response.
    pub async fn wait_for_feed(
        &self,
        feed_id: &str,
        options: WaitOptions,
    ) -> Result<TypedResponse<feeds::models::Feed>, WorkflowError> {
        let id = id(feed_id)?;
        poll(
            options,
            |feed: &feeds::models::Feed| feed.processing_status.clone(),
            || feeds::get_feed(&self.client, feeds::GetFeedParams::new(id.clone())),
        )
        .await
    }

    /// Poll `getQuery` until DONE, CANCELLED or FATAL and return that response.
    pub async fn wait_for_query(
        &self,
        query_id: &str,
        options: WaitOptions,
    ) -> Result<TypedResponse<kiosk::models::Query>, WorkflowError> {
        let id = id(query_id)?;
        poll(
            options,
            |query: &kiosk::models::Query| query.processing_status.clone(),
            || kiosk::get_query(&self.client, kiosk::GetQueryParams::new(id.clone())),
        )
        .await
    }

    /// Create a feed document with exactly `content_type`, then upload the source
    /// to its signed URL with the same Content-Type. See [`Self::create_feed_document`].
    pub async fn create_and_upload_feed_document<S, E>(
        &self,
        content_type: &str,
        source: S,
        options: UploadOptions,
    ) -> Result<FeedDocumentUpload, WorkflowError>
    where
        S: Stream<Item = Result<Bytes, E>> + Send + 'static,
        E: Send + 'static,
    {
        self.create_feed_document(content_type, &options)
            .await?
            .upload(source, options)
            .await
    }

    /// Only create the feed document. `options` are validated and their transfer
    /// timeout starts the one total deadline, shared with the later
    /// [`FeedDocumentTarget::upload`]. Create is never retried and `createFeed` is
    /// not called. The signed URL stays private to the returned target.
    pub async fn create_feed_document(
        &self,
        content_type: &str,
        options: &UploadOptions,
    ) -> Result<FeedDocumentTarget, WorkflowError> {
        let mut checked = options.clone();
        checked.content_type = content_type.to_owned();
        let deadline =
            documents::check_upload(&checked).map_err(|_| WorkflowError::InvalidConfig)?;
        let (created, _) = metadata(
            deadline,
            201,
            feeds::create_feed_document(
                &self.client,
                feeds::CreateFeedDocumentParams::new(
                    serde_json::json!({ "contentType": content_type }),
                ),
            ),
        )
        .await?;
        if created.feed_document_id.is_empty() || created.url.is_empty() {
            return Err(WorkflowError::Metadata);
        }
        documents::check_url(&created.url).map_err(|_| WorkflowError::Metadata)?;
        Ok(FeedDocumentTarget {
            client: self.client.documents(),
            document_id: created.feed_document_id,
            url: created.url,
            content_type: content_type.to_owned(),
            deadline,
        })
    }

    fn start(options: &TransferOptions) -> Result<Instant, WorkflowError> {
        options.deadline().map_err(|_| WorkflowError::InvalidConfig)
    }

    async fn transfer(
        &self,
        deadline: Instant,
        mut options: TransferOptions,
        url: &str,
        declared: Declared,
    ) -> Result<Download, WorkflowError> {
        if url.is_empty() {
            return Err(WorkflowError::Metadata);
        }
        options.compression = resolve(options.compression, declared)?;
        documents::check_url(url).map_err(|_| WorkflowError::Metadata)?;
        options.timeout = remaining(deadline)?;
        self.client
            .documents()
            .download(url, options)
            .await
            .map_err(document_error)
    }
}

async fn poll<T, F, Fut>(
    options: WaitOptions,
    status: fn(&T) -> String,
    fetch: F,
) -> Result<TypedResponse<T>, WorkflowError>
where
    T: DeserializeOwned,
    F: Fn() -> Fut,
    Fut: Future<Output = Result<TypedResponse<T>, ClientError>>,
{
    if options.interval.is_zero() {
        return Err(WorkflowError::InvalidConfig);
    }
    let deadline = crate::deadline(options.timeout).ok_or(WorkflowError::InvalidConfig)?;
    loop {
        // A late timer wake must not start one more poll after the deadline.
        remaining(deadline)?;
        let (value, typed) = metadata(deadline, 200, fetch()).await?;
        match status(&value).as_str() {
            "DONE" | "CANCELLED" | "FATAL" => return Ok(typed),
            "IN_QUEUE" | "IN_PROGRESS" => {}
            _ => return Err(WorkflowError::Status),
        }
        let next = Instant::now().checked_add(options.interval);
        match next {
            Some(next) if next < deadline => sleep_until(next).await,
            _ => {
                sleep_until(deadline).await;
                return Err(WorkflowError::Timeout);
            }
        }
    }
}
