//! Native document handles: owned streams, shared runtime and bounded uploads.
use super::{Completed, Engine, ForkOwned, Response, Shared, gvl, native_error};
use bytes::Bytes;
use futures_util::{FutureExt, StreamExt};
use magnus::{Error, IntoValue, RClass, RModule, RString, Ruby, method, prelude::*};
use peddler::documents::{
    Compression, DocumentStream, Download, Error as DocumentError, TransferOptions, UploadOptions,
    UploadResponse,
};
use std::{
    panic::AssertUnwindSafe,
    sync::{Arc, Mutex},
    time::Duration,
};
use tokio::{
    sync::{Notify, mpsc},
    task::AbortHandle,
};

pub(super) fn error(ruby: &Ruby, error: DocumentError) -> Error {
    let message = error.to_string();
    match error {
        DocumentError::InvalidConfig | DocumentError::InvalidUrl | DocumentError::InvalidHeader => {
            Error::new(ruby.exception_arg_error(), message)
        }
        DocumentError::Timeout => native_error(ruby, "DocumentTimeoutError", &message),
        _ => native_error(ruby, "DocumentError", &message),
    }
}
fn misuse(ruby: &Ruby) -> Error {
    native_error(
        ruby,
        "DocumentError",
        "document is closed, busy or already consumed in another mode",
    )
}
fn headers(values: &http::HeaderMap) -> Vec<(String, String)> {
    values
        .iter()
        .map(|(key, value)| {
            (
                key.as_str().to_owned(),
                String::from_utf8_lossy(value.as_bytes()).into_owned(),
            )
        })
        .collect()
}

#[derive(serde::Deserialize, Default)]
#[serde(deny_unknown_fields)]
pub(super) struct Config {
    timeout: Option<f64>,
    compression: Option<String>,
    max_bytes: Option<u64>,
    max_record_bytes: Option<usize>,
    max_records: Option<u64>,
    max_response_bytes: Option<usize>,
}
impl Config {
    pub(super) fn parse(ruby: &Ruby, json: &str) -> Result<TransferOptions, Error> {
        let value: Self =
            serde_json::from_str(json).map_err(|_| error(ruby, DocumentError::InvalidConfig))?;
        let mut options = TransferOptions::default();
        if let Some(timeout) = value.timeout {
            options.timeout = Duration::try_from_secs_f64(timeout)
                .map_err(|_| error(ruby, DocumentError::InvalidConfig))?;
        }
        if let Some(compression) = value.compression {
            options.compression = match compression.as_str() {
                "auto" => Compression::Auto,
                "none" => Compression::None,
                "gzip" => Compression::Gzip,
                _ => return Err(error(ruby, DocumentError::InvalidConfig)),
            };
        }
        if let Some(value) = value.max_bytes {
            options.max_bytes = value;
        }
        if let Some(value) = value.max_record_bytes {
            options.max_record_bytes = value;
        }
        if let Some(value) = value.max_records {
            options.max_records = value;
        }
        if let Some(value) = value.max_response_bytes {
            options.max_response_bytes = value;
        }
        Ok(options)
    }
}

enum StreamState {
    Fresh(Box<Download>),
    Chunks(DocumentStream<Bytes>),
    Jsonl(DocumentStream<serde_json::Value>),
    Tsv(DocumentStream<Vec<String>>),
    Busy,
    Closed,
}
struct DocumentOwner {
    shared: &'static Shared,
    stream: Arc<Mutex<StreamState>>,
    close_signal: Arc<Notify>,
    status: u16,
    headers: Vec<(String, String)>,
    charset: Option<String>,
    error_body: Option<Vec<u8>>,
    truncated: bool,
}
#[magnus::wrap(class = "Peddler::Native::DocumentHandle", free_immediately)]
pub(super) struct Document(ForkOwned<DocumentOwner>);
// Lives outside protect: interrupted reads close the handle as well as the owned
// active future. Mutexes never cover await, stream Drop or Ruby calls.
struct ReadLease {
    state: Arc<Mutex<StreamState>>,
    restored: bool,
}
impl ReadLease {
    fn restore(&mut self, value: StreamState) {
        let old = {
            let mut state = self.state.lock().unwrap();
            if matches!(*state, StreamState::Busy) {
                Some(std::mem::replace(&mut *state, value))
            } else {
                None
            }
        };
        drop(old);
        self.restored = true;
    }
}
impl Drop for ReadLease {
    fn drop(&mut self) {
        if !self.restored {
            let old = std::mem::replace(&mut *self.state.lock().unwrap(), StreamState::Closed);
            drop(old);
        }
    }
}
enum Row {
    Chunk(Bytes),
    Json(String),
    Tsv(Vec<String>),
}
impl Document {
    fn download(ruby: &Ruby, engine: &Engine, url: String, json: String) -> Result<Self, Error> {
        let state = engine.0.get(ruby)?;
        let options = Config::parse(ruby, &json)?;
        let client = state.client.documents();
        let shared = state.shared;
        let download = gvl::wait(ruby, "DocumentError", shared, async move {
            client.download(&url, options).await
        })?
        .map_err(|e| error(ruby, e))?;
        Ok(Self::from_download(shared, download))
    }
    /// Shared by raw URL downloads and the ID-based workflow downloads.
    pub(super) fn from_download(shared: &'static Shared, download: Download) -> Self {
        Self(ForkOwned::new(DocumentOwner {
            status: download.status(),
            headers: headers(download.headers()),
            charset: download.charset(),
            error_body: download.error_body().map(<[u8]>::to_vec),
            truncated: download.error_body_truncated(),
            shared,
            stream: Arc::new(Mutex::new(StreamState::Fresh(Box::new(download)))),
            close_signal: Arc::new(Notify::new()),
        }))
    }
    fn close(ruby: &Ruby, document: &Self) -> Result<(), Error> {
        let owner = document.0.get(ruby)?;
        let old = std::mem::replace(&mut *owner.stream.lock().unwrap(), StreamState::Closed);
        drop(old);
        owner.close_signal.notify_waiters();
        Ok(())
    }
    fn closed(ruby: &Ruby, document: &Self) -> Result<bool, Error> {
        let owner = document.0.get(ruby)?;
        Ok(matches!(*owner.stream.lock().unwrap(), StreamState::Closed))
    }
    fn status(ruby: &Ruby, document: &Self) -> Result<u16, Error> {
        Ok(document.0.get(ruby)?.status)
    }
    fn headers(ruby: &Ruby, document: &Self) -> Result<Vec<(String, String)>, Error> {
        Ok(document.0.get(ruby)?.headers.clone())
    }
    fn charset(ruby: &Ruby, document: &Self) -> Result<Option<String>, Error> {
        Ok(document.0.get(ruby)?.charset.clone())
    }
    fn error_body(ruby: &Ruby, document: &Self) -> Result<Option<RString>, Error> {
        let owner = document.0.get(ruby)?;
        Ok(owner
            .error_body
            .as_ref()
            .map(|bytes| ruby.str_from_slice(bytes)))
    }
    fn truncated(ruby: &Ruby, document: &Self) -> Result<bool, Error> {
        Ok(document.0.get(ruby)?.truncated)
    }
    fn take(ruby: &Ruby, owner: &DocumentOwner) -> Result<(ReadLease, StreamState), Error> {
        let mut state = owner.stream.lock().unwrap();
        if matches!(*state, StreamState::Closed | StreamState::Busy) {
            drop(state);
            return Err(misuse(ruby));
        }
        let owned = std::mem::replace(&mut *state, StreamState::Busy);
        Ok((
            ReadLease {
                state: Arc::clone(&owner.stream),
                restored: false,
            },
            owned,
        ))
    }
    fn next(
        ruby: &Ruby,
        document: &Self,
        mode: String,
        consistent: bool,
        charset: Option<String>,
    ) -> Result<Option<magnus::Value>, Error> {
        let owner = document.0.get(ruby)?;
        let (mut lease, state) = Self::take(ruby, owner)?;
        let mut state = match (mode.as_str(), state) {
            ("chunks", StreamState::Fresh(value)) => StreamState::Chunks((*value).into_chunks()),
            ("jsonl", StreamState::Fresh(value)) => StreamState::Jsonl((*value).into_jsonl()),
            ("tsv", StreamState::Fresh(value)) => StreamState::Tsv(match charset {
                Some(label) => (*value).into_tsv_with_charset(consistent, &label),
                None => (*value).into_tsv(consistent),
            }),
            ("chunks", state @ StreamState::Chunks(_))
            | ("jsonl", state @ StreamState::Jsonl(_))
            | ("tsv", state @ StreamState::Tsv(_)) => state,
            _ => return Err(misuse(ruby)),
        };
        let closed = Arc::clone(&owner.stream);
        let signal = Arc::clone(&owner.close_signal);
        let (state, row) = gvl::wait(ruby, "DocumentError", owner.shared, async move {
            let read = async {
                match &mut state {
                    StreamState::Chunks(stream) => stream
                        .next()
                        .await
                        .transpose()
                        .map(|row| row.map(Row::Chunk)),
                    StreamState::Jsonl(stream) => stream
                        .next()
                        .await
                        .transpose()
                        .map(|row| row.map(|value| Row::Json(value.to_string()))),
                    StreamState::Tsv(stream) => {
                        stream.next().await.transpose().map(|row| row.map(Row::Tsv))
                    }
                    _ => unreachable!(),
                }
            };
            let row = tokio::select! {
                row = read => row,
                () = wait_closed(closed, signal) => Err(DocumentError::Transport),
            };
            (state, row)
        })?;
        let row = row.map_err(|e| error(ruby, e))?;
        if row.is_some() {
            lease.restore(state);
        }
        Ok(row.map(|row| match row {
            Row::Chunk(bytes) => ruby.str_from_slice(&bytes).as_value(),
            Row::Json(json) => ruby.str_new(&json).as_value(),
            Row::Tsv(fields) => fields.into_value_with(ruby),
        }))
    }
    fn json(ruby: &Ruby, document: &Self, limit: usize) -> Result<String, Error> {
        let owner = document.0.get(ruby)?;
        let (_lease, state) = Self::take(ruby, owner)?;
        let StreamState::Fresh(value) = state else {
            return Err(misuse(ruby));
        };
        let closed = Arc::clone(&owner.stream);
        let signal = Arc::clone(&owner.close_signal);
        let result = gvl::wait(ruby, "DocumentError", owner.shared, async move {
            tokio::select! {
                result = (*value).json(limit) => result,
                () = wait_closed(closed, signal) => Err(DocumentError::Transport),
            }
        })?;
        result
            .map(|value| value.to_string())
            .map_err(|e| error(ruby, e))
    }
}

/// Returns once `done` holds. It registers before checking, so a `notify_waiters`
/// between the check and the wait is not missed.
async fn until(notify: &Notify, done: impl Fn() -> bool) {
    loop {
        let notified = notify.notified();
        tokio::pin!(notified);
        notified.as_mut().enable();
        if done() {
            return;
        }
        notified.await;
    }
}
async fn wait_closed(state: Arc<Mutex<StreamState>>, signal: Arc<Notify>) {
    until(&signal, || {
        matches!(*state.lock().unwrap(), StreamState::Closed)
    })
    .await;
}
enum UploadState {
    Pending,
    Ready(Result<UploadResponse, DocumentError>),
    Taken,
}
struct Completion {
    result: Mutex<UploadState>,
    notify: Notify,
}
impl Completion {
    async fn ready(&self) {
        until(&self.notify, || {
            !matches!(*self.result.lock().unwrap(), UploadState::Pending)
        })
        .await;
    }
    /// Keeps the first result and wakes every waiter.
    fn settle(&self, result: Result<UploadResponse, DocumentError>) {
        let mut state = self.result.lock().unwrap();
        if matches!(*state, UploadState::Pending) {
            *state = UploadState::Ready(result);
        }
        drop(state);
        self.notify.notify_waiters();
    }
}
pub(super) type UploadSource =
    std::pin::Pin<Box<dyn futures_util::Stream<Item = Result<Bytes, ()>> + Send + 'static>>;
type UploadParts = (
    u16,
    Vec<(String, String)>,
    RString,
    Option<super::ErrorMetadata>,
    bool,
);
struct UploadOwner {
    shared: &'static Shared,
    document_id: Option<String>,
    sender: Mutex<Option<mpsc::Sender<Bytes>>>,
    completion: Arc<Completion>,
    abort: AbortHandle,
}
impl Drop for UploadOwner {
    fn drop(&mut self) {
        self.abort.abort();
    }
}
#[magnus::wrap(class = "Peddler::Native::UploadHandle", free_immediately)]
pub(super) struct Upload(ForkOwned<UploadOwner>);
impl Upload {
    fn start(
        ruby: &Ruby,
        engine: &Engine,
        url: String,
        config: String,
        content_type: String,
        headers: Vec<(String, String)>,
        content_length: Option<u64>,
    ) -> Result<Self, Error> {
        let state = engine.0.get(ruby)?;
        let options = UploadOptions {
            transfer: Config::parse(ruby, &config)?,
            content_type,
            headers,
            content_length,
        };
        let client = state.client.documents();
        Self::spawn(state.shared, None, move |source| async move {
            client.upload(&url, source, options).await
        })
    }
    /// Start a bounded upload task whose body is fed through a capacity-1 channel.
    /// `make` builds the transfer future from the owned source stream.
    pub(super) fn spawn<F, Fut>(
        shared: &'static Shared,
        document_id: Option<String>,
        make: F,
    ) -> Result<Self, Error>
    where
        F: FnOnce(UploadSource) -> Fut,
        Fut: std::future::Future<Output = Result<UploadResponse, DocumentError>> + Send + 'static,
    {
        let (sender, receiver) = mpsc::channel::<Bytes>(1);
        let completion = Arc::new(Completion {
            result: Mutex::new(UploadState::Pending),
            notify: Notify::new(),
        });
        let target = Arc::clone(&completion);
        let source = futures_util::stream::unfold(receiver, |mut receiver| async move {
            receiver
                .recv()
                .await
                .map(|value| (Ok::<_, ()>(value), receiver))
        });
        let work = make(Box::pin(source));
        let worker = shared.runtime.spawn(async move {
            let result = match AssertUnwindSafe(work).catch_unwind().await {
                Ok(result) => result,
                Err(payload) => {
                    std::mem::forget(payload);
                    Err(DocumentError::Transport)
                }
            };
            target.settle(result);
        });
        let abort = worker.abort_handle();
        drop(worker);
        Ok(Self(ForkOwned::new(UploadOwner {
            shared,
            document_id,
            sender: Mutex::new(Some(sender)),
            completion,
            abort,
        })))
    }
    fn document_id(ruby: &Ruby, upload: &Self) -> Result<Option<String>, Error> {
        Ok(upload.0.get(ruby)?.document_id.clone())
    }
    fn completed(ruby: &Ruby, upload: &Self) -> Result<bool, Error> {
        let owner = upload.0.get(ruby)?;
        Ok(!matches!(
            *owner.completion.result.lock().unwrap(),
            UploadState::Pending
        ))
    }
    fn push(ruby: &Ruby, upload: &Self, bytes: RString) -> Result<bool, Error> {
        let owner = upload.0.get(ruby)?;
        // SAFETY: bounded Ruby bytes copied under GVL; none escape into Tokio.
        let data = unsafe { bytes.as_slice() };
        if data.len() > 64 << 10 {
            return Err(error(ruby, DocumentError::InvalidConfig));
        }
        let data = Bytes::copy_from_slice(data);
        let sender = owner.sender.lock().unwrap().as_ref().cloned();
        let sender = sender.ok_or_else(|| misuse(ruby))?;
        let completion = Arc::clone(&owner.completion);
        gvl::wait(ruby, "DocumentError", owner.shared, async move {
            tokio::select! { biased;
                () = completion.ready() => false,
                permit = sender.reserve() => match permit { Ok(permit) => { permit.send(data); true }, Err(_) => false },
            }
        })
    }
    fn finish(ruby: &Ruby, upload: &Self) -> Result<UploadParts, Error> {
        let owner = upload.0.get(ruby)?;
        let sender = owner.sender.lock().unwrap().take();
        drop(sender);
        let completion = Arc::clone(&owner.completion);
        let response = gvl::wait(ruby, "DocumentError", owner.shared, async move {
            completion.ready().await;
            match std::mem::replace(&mut *completion.result.lock().unwrap(), UploadState::Taken) {
                UploadState::Ready(result) => result,
                _ => Err(DocumentError::UploadSource),
            }
        })?
        .map_err(|e| error(ruby, e))?;
        let truncated = response.body_truncated;
        let completed = Completed::new(Response {
            status: response.status,
            headers: headers(&response.headers),
            body: response.body,
        });
        let (status, headers, body, metadata) = completed.into_parts(ruby);
        Ok((status, headers, body, metadata, truncated))
    }
    fn close(ruby: &Ruby, upload: &Self) -> Result<(), Error> {
        let owner = upload.0.get(ruby)?;
        owner.abort.abort();
        owner.completion.settle(Err(DocumentError::UploadSource));
        let sender = owner.sender.lock().unwrap().take();
        drop(sender);
        Ok(())
    }
}
pub(super) fn init(
    ruby: &Ruby,
    peddler: RModule,
    native: RModule,
    engine: RClass,
) -> Result<(), Error> {
    let error = peddler.define_class(
        "DocumentError",
        ruby.exception_standard_error().as_r_class(),
    )?;
    peddler.define_class("DocumentTimeoutError", error)?;
    engine.define_method("download_document", method!(Document::download, 2))?;
    engine.define_method("start_document_upload", method!(Upload::start, 5))?;
    let document = native.define_class("DocumentHandle", ruby.class_object())?;
    document.define_method("close", method!(Document::close, 0))?;
    document.define_method("closed?", method!(Document::closed, 0))?;
    document.define_method("status", method!(Document::status, 0))?;
    document.define_method("headers", method!(Document::headers, 0))?;
    document.define_method("charset", method!(Document::charset, 0))?;
    document.define_method("error_body", method!(Document::error_body, 0))?;
    document.define_method("error_body_truncated?", method!(Document::truncated, 0))?;
    document.define_method("next_row", method!(Document::next, 3))?;
    document.define_method("json", method!(Document::json, 1))?;
    let upload = native.define_class("UploadHandle", ruby.class_object())?;
    upload.define_method("completed?", method!(Upload::completed, 0))?;
    upload.define_method("push", method!(Upload::push, 1))?;
    upload.define_method("finish", method!(Upload::finish, 0))?;
    upload.define_method("close", method!(Upload::close, 0))?;
    upload.define_method("document_id", method!(Upload::document_id, 0))?;
    // No public constructors: handles originate from an Engine.
    Ok(())
}
