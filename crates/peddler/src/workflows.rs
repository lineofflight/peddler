//! Report, feed and Data Kiosk document lifecycle helpers.
//!
//! Metadata requests use the generated operations, so they carry the client's access
//! token and follow its retry policy. Signed document transfers use the
//! credential-free document client. Each helper takes one explicit total deadline
//! (`TransferOptions::timeout`, `UploadOptions::transfer.timeout` or
//! `WaitOptions::timeout`), measured from the call. Time spent on metadata is
//! deducted before the transfer starts, so the transfer receives the remainder.
//! The deadline also covers reading the downloaded body, and the waits between the
//! attempts of a metadata request the client retries: a wait that would outlast the
//! deadline ends there, and the helper has timed out. A request that is told to wait
//! longer than the client waits is not retried, so its 429 is [`WorkflowError::Http`]
//! at once.
//!
//! No helper retries a transfer or submits a feed. Creating a feed document is
//! retried as the client retries any write: after a 429 only, which made no
//! document. Error messages never contain signed URLs, response bodies or tokens. A
//! failed metadata response is available through [`WorkflowError::response`], and
//! the reply of a signed URL that rejects a transfer through
//! [`documents::Error::Rejected`].

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

/// What a workflow helper fetches or waits for.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
#[non_exhaustive]
pub enum DocumentKind {
    /// A report and its document.
    Report,
    /// A feed, and the document of its result.
    Feed,
    /// A Data Kiosk query and its document.
    Query,
}

/// Polling interval and total timeout. Both must be positive.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct WaitOptions {
    /// The time between the end of one poll and the start of the next.
    pub interval: Duration,
    /// One deadline for the whole wait.
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

/// A created feed document awaiting its upload. Debug hides the signed URL.
pub struct FeedDocumentTarget {
    client: documents::DocumentClient,
    /// The ID to pass to `createFeed` once the upload is done.
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
    /// polled here, never before valid metadata exists. Not retried. A reply outside
    /// 2xx is [`documents::Error::Rejected`] in [`WorkflowError::Upload`].
    pub async fn upload<S, E>(
        self,
        source: S,
        mut options: UploadOptions,
    ) -> Result<UploadResponse, WorkflowError>
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
            remaining(deadline).ok_or_else(|| failed(documents::Error::Timeout))?;
        client.upload(&url, source, options).await.map_err(failed)
    }
}

/// Why a helper failed. Debug and Display show no URL, body or token.
#[non_exhaustive]
pub enum WorkflowError {
    /// Invalid identifier, content type, interval, timeout or transfer limits.
    InvalidConfig,
    /// Metadata request failed before an HTTP response. A lookup whose last attempt
    /// takes longer than the client's timeout, or that takes longer than the deadline
    /// of its call with its retries, is [`ClientError::Timeout`] here.
    Request(ClientError),
    /// Metadata response had an unexpected status. Raw response retained.
    Http(Response),
    /// Metadata was malformed, or its document URL was missing or invalid.
    Metadata,
    /// Processing status was not one this library knows.
    Status,
    /// Metadata names a compression algorithm other than GZIP.
    UnsupportedCompression,
    /// A wait ran past its own timeout. Nothing else is this: a request that times
    /// out is [`Self::Request`], a transfer [`Self::Document`] or [`Self::Upload`].
    Timeout,
    /// Download failed to start, ran out of time, or its signed URL answered outside
    /// 2xx.
    Document(documents::Error),
    /// Upload failed or ran out of time after the feed document was created.
    Upload {
        /// The feed document that was created.
        document_id: String,
        /// Why the upload failed.
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
            Self::Timeout => f.write_str("wait timed out"),
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
    /// The helpers that wait for a report, feed or query and transfer its document.
    pub fn workflows(&self) -> Workflows {
        Workflows {
            client: self.clone(),
        }
    }
}

/// The compression the metadata declares: GZIP, or none, which leaves it to the
/// caller's option and the HTTP Content-Encoding header.
fn declared(algorithm: Option<&str>) -> Result<Option<Compression>, WorkflowError> {
    match algorithm {
        None => Ok(None),
        Some("GZIP") => Ok(Some(Compression::Gzip)),
        Some(_) => Err(WorkflowError::UnsupportedCompression),
    }
}
fn request_error(error: ClientError) -> WorkflowError {
    match error {
        ClientError::InvalidRequest => WorkflowError::InvalidConfig,
        error => WorkflowError::Request(error),
    }
}
fn id(value: &str) -> Result<String, WorkflowError> {
    if value.is_empty() {
        Err(WorkflowError::InvalidConfig)
    } else {
        Ok(value.to_owned())
    }
}
/// The time left before the deadline, if any is.
fn remaining(deadline: Instant) -> Option<Duration> {
    let left = deadline.saturating_duration_since(Instant::now());
    (!left.is_zero()).then_some(left)
}
/// One metadata request under the deadline, or `late` when the deadline comes first.
/// The reply must carry exactly `status` and decode. The model comes with the
/// response it was read from.
async fn metadata<T: DeserializeOwned>(
    deadline: Instant,
    late: WorkflowError,
    status: u16,
    call: impl Future<Output = Result<TypedResponse<T>, ClientError>>,
) -> Result<(T, TypedResponse<T>), WorkflowError> {
    let typed = timeout_at(deadline, call)
        .await
        .map_err(|_| late)?
        .map_err(request_error)?;
    if typed.raw.status != status {
        return Err(WorkflowError::Http(typed.into_raw()));
    }
    let model = typed.json().map_err(|_| WorkflowError::Metadata)?;
    Ok((model, typed))
}
/// The request that looks up or creates a document. Past the deadline of the whole
/// call it has timed out as a request does.
async fn lookup<T: DeserializeOwned>(
    deadline: Instant,
    status: u16,
    call: impl Future<Output = Result<TypedResponse<T>, ClientError>>,
) -> Result<(T, TypedResponse<T>), WorkflowError> {
    let late = WorkflowError::Request(ClientError::Timeout);
    metadata(deadline, late, status, call).await
}

impl Workflows {
    /// Download a report, feed or Data Kiosk document by its ID. Data Kiosk documents
    /// declare compression only through Content-Encoding.
    pub async fn download(
        &self,
        kind: DocumentKind,
        document_id: &str,
        options: TransferOptions,
    ) -> Result<Download, WorkflowError> {
        let id = id(document_id)?;
        let deadline = Self::start(&options)?;
        let (url, declared) = match kind {
            DocumentKind::Report => {
                let (document, _) = lookup(
                    deadline,
                    200,
                    reports::get_report_document(
                        &self.client,
                        reports::GetReportDocumentParams::new(id),
                    ),
                )
                .await?;
                let declared = declared(document.compression_algorithm.as_deref())?;
                (document.url, declared)
            }
            DocumentKind::Feed => {
                let (document, _) = lookup(
                    deadline,
                    200,
                    feeds::get_feed_document(&self.client, feeds::GetFeedDocumentParams::new(id)),
                )
                .await?;
                let declared = declared(document.compression_algorithm.as_deref())?;
                (document.url, declared)
            }
            DocumentKind::Query => {
                let (document, _) = lookup(
                    deadline,
                    200,
                    kiosk::get_document(&self.client, kiosk::GetDocumentParams::new(id)),
                )
                .await?;
                (document.document_url, None)
            }
        };
        self.transfer(deadline, options, &url, declared).await
    }

    /// Download a report by its document ID. A document whose metadata says `GZIP`
    /// is decompressed.
    pub async fn download_report_document(
        &self,
        document_id: &str,
        options: TransferOptions,
    ) -> Result<Download, WorkflowError> {
        self.download(DocumentKind::Report, document_id, options)
            .await
    }

    /// Download the result of a feed by its document ID, decompressed as a report is.
    pub async fn download_feed_document(
        &self,
        document_id: &str,
        options: TransferOptions,
    ) -> Result<Download, WorkflowError> {
        self.download(DocumentKind::Feed, document_id, options)
            .await
    }

    /// Download a Data Kiosk document by its ID.
    pub async fn download_query_document(
        &self,
        document_id: &str,
        options: TransferOptions,
    ) -> Result<Download, WorkflowError> {
        self.download(DocumentKind::Query, document_id, options)
            .await
    }

    /// Poll `getReport`, `getFeed` or `getQuery` until DONE, CANCELLED or FATAL and
    /// return that response.
    pub async fn wait(
        &self,
        kind: DocumentKind,
        processing_id: &str,
        options: WaitOptions,
    ) -> Result<Response, WorkflowError> {
        let id = id(processing_id)?;
        match kind {
            DocumentKind::Report => poll(
                options,
                |report: &reports::models::Report| report.processing_status.clone(),
                || reports::get_report(&self.client, reports::GetReportParams::new(id.clone())),
            )
            .await
            .map(TypedResponse::into_raw),
            DocumentKind::Feed => poll(
                options,
                |feed: &feeds::models::Feed| feed.processing_status.clone(),
                || feeds::get_feed(&self.client, feeds::GetFeedParams::new(id.clone())),
            )
            .await
            .map(TypedResponse::into_raw),
            DocumentKind::Query => poll(
                options,
                |query: &kiosk::models::Query| query.processing_status.clone(),
                || kiosk::get_query(&self.client, kiosk::GetQueryParams::new(id.clone())),
            )
            .await
            .map(TypedResponse::into_raw),
        }
    }

    /// Poll `getReport` until the report is DONE, CANCELLED or FATAL.
    pub async fn wait_for_report(
        &self,
        report_id: &str,
        options: WaitOptions,
    ) -> Result<TypedResponse<reports::models::Report>, WorkflowError> {
        self.wait(DocumentKind::Report, report_id, options)
            .await
            .map(TypedResponse::new)
    }

    /// Poll `getFeed` until the feed is DONE, CANCELLED or FATAL.
    pub async fn wait_for_feed(
        &self,
        feed_id: &str,
        options: WaitOptions,
    ) -> Result<TypedResponse<feeds::models::Feed>, WorkflowError> {
        self.wait(DocumentKind::Feed, feed_id, options)
            .await
            .map(TypedResponse::new)
    }

    /// Poll `getQuery` until the query is DONE, CANCELLED or FATAL.
    pub async fn wait_for_query(
        &self,
        query_id: &str,
        options: WaitOptions,
    ) -> Result<TypedResponse<kiosk::models::Query>, WorkflowError> {
        self.wait(DocumentKind::Query, query_id, options)
            .await
            .map(TypedResponse::new)
    }

    /// Create a feed document with exactly `content_type`, then upload the source
    /// to its signed URL with the same Content-Type, and return the feed document
    /// ID. `createFeed` is never called. See [`Self::create_feed_document`].
    pub async fn create_and_upload_feed_document<S, E>(
        &self,
        content_type: &str,
        source: S,
        options: UploadOptions,
    ) -> Result<String, WorkflowError>
    where
        S: Stream<Item = Result<Bytes, E>> + Send + 'static,
        E: Send + 'static,
    {
        let target = self.create_feed_document(content_type, &options).await?;
        let document_id = target.document_id.clone();
        target.upload(source, options).await?;
        Ok(document_id)
    }

    /// Only create the feed document. `options` are validated and their transfer
    /// timeout starts the one total deadline, shared with the later
    /// [`FeedDocumentTarget::upload`]. Create is retried as the client retries a
    /// write, after a 429 only, and `createFeed` is not called. The signed URL stays
    /// private to the returned target.
    pub async fn create_feed_document(
        &self,
        content_type: &str,
        options: &UploadOptions,
    ) -> Result<FeedDocumentTarget, WorkflowError> {
        let mut checked = options.clone();
        checked.content_type = content_type.to_owned();
        let deadline =
            documents::check_upload(&checked).map_err(|_| WorkflowError::InvalidConfig)?;
        let (created, _) = lookup(
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
        declared: Option<Compression>,
    ) -> Result<Download, WorkflowError> {
        if url.is_empty() {
            return Err(WorkflowError::Metadata);
        }
        if let Some(compression) = declared {
            options.compression = compression;
        }
        documents::check_url(url).map_err(|_| WorkflowError::Metadata)?;
        options.timeout =
            remaining(deadline).ok_or(WorkflowError::Document(documents::Error::Timeout))?;
        self.client
            .documents()
            .download(url, options)
            .await
            .map_err(WorkflowError::Document)
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
        remaining(deadline).ok_or(WorkflowError::Timeout)?;
        let (value, typed) = metadata(deadline, WorkflowError::Timeout, 200, fetch()).await?;
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
