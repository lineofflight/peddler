//! Native document handles: owned streams, shared runtime and bounded uploads.
use super::{Completed, Engine, Response, RuntimeOwner, gvl, native_error};
use bytes::Bytes;
use futures_util::{FutureExt, StreamExt};
use magnus::{Error, IntoValue, RClass, RModule, RString, Ruby, method, prelude::*};
use peddler::documents::{
    Compression, DocumentStream, Download, Error as DocumentError, TransferOptions, UploadOptions,
    UploadResponse,
};
use std::{
    mem::ManuallyDrop,
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
pub(super) fn guard(ruby: &Ruby, pid: u32) -> Result<(), Error> {
    if pid != std::process::id() {
        Err(native_error(
            ruby,
            "ForkError",
            "create a new client after fork",
        ))
    } else {
        Ok(())
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
    runtime: Arc<RuntimeOwner>,
    stream: Arc<Mutex<StreamState>>,
    close_signal: Arc<Notify>,
    status: u16,
    headers: Vec<(String, String)>,
    error_body: Option<Vec<u8>>,
    truncated: bool,
}
#[magnus::wrap(class = "Peddler::Native::DocumentHandle", free_immediately)]
pub(super) struct Document {
    pid: u32,
    owner: ManuallyDrop<DocumentOwner>,
}
impl Drop for Document {
    fn drop(&mut self) {
        if self.pid == std::process::id() {
            // SAFETY: only the creator drops sockets/runtime/locks. A fork child
            // intentionally leaks inherited state rather than touching it.
            unsafe { ManuallyDrop::drop(&mut self.owner) };
        }
    }
}
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
        guard(ruby, engine.pid)?;
        let options = Config::parse(ruby, &json)?;
        let client = engine.state.client.documents();
        let runtime = Arc::clone(&engine.state.runtime);
        let download = gvl::wait(ruby, "DocumentError", Arc::clone(&runtime), async move {
            client.download(&url, options).await
        })?
        .map_err(|e| error(ruby, e))?;
        Ok(Self::from_download(engine.pid, runtime, download))
    }
    /// Shared by raw URL downloads and the ID-based workflow downloads.
    pub(super) fn from_download(pid: u32, runtime: Arc<RuntimeOwner>, download: Download) -> Self {
        Self {
            pid,
            owner: ManuallyDrop::new(DocumentOwner {
                status: download.status(),
                headers: headers(download.headers()),
                error_body: download.error_body().map(<[u8]>::to_vec),
                truncated: download.error_body_truncated(),
                runtime,
                stream: Arc::new(Mutex::new(StreamState::Fresh(Box::new(download)))),
                close_signal: Arc::new(Notify::new()),
            }),
        }
    }
    fn close(ruby: &Ruby, document: &Self) -> Result<(), Error> {
        guard(ruby, document.pid)?;
        let old = std::mem::replace(
            &mut *document.owner.stream.lock().unwrap(),
            StreamState::Closed,
        );
        drop(old);
        document.owner.close_signal.notify_waiters();
        Ok(())
    }
    fn closed(ruby: &Ruby, document: &Self) -> Result<bool, Error> {
        guard(ruby, document.pid)?;
        Ok(matches!(
            *document.owner.stream.lock().unwrap(),
            StreamState::Closed
        ))
    }
    fn status(ruby: &Ruby, document: &Self) -> Result<u16, Error> {
        guard(ruby, document.pid)?;
        Ok(document.owner.status)
    }
    fn headers(ruby: &Ruby, document: &Self) -> Result<Vec<(String, String)>, Error> {
        guard(ruby, document.pid)?;
        Ok(document.owner.headers.clone())
    }
    fn error_body(ruby: &Ruby, document: &Self) -> Result<Option<RString>, Error> {
        guard(ruby, document.pid)?;
        Ok(document
            .owner
            .error_body
            .as_ref()
            .map(|bytes| ruby.str_from_slice(bytes)))
    }
    fn truncated(ruby: &Ruby, document: &Self) -> Result<bool, Error> {
        guard(ruby, document.pid)?;
        Ok(document.owner.truncated)
    }
    fn take(ruby: &Ruby, document: &Self) -> Result<(ReadLease, StreamState), Error> {
        guard(ruby, document.pid)?;
        let mut state = document.owner.stream.lock().unwrap();
        if matches!(*state, StreamState::Closed | StreamState::Busy) {
            drop(state);
            return Err(misuse(ruby));
        }
        let owned = std::mem::replace(&mut *state, StreamState::Busy);
        Ok((
            ReadLease {
                state: Arc::clone(&document.owner.stream),
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
    ) -> Result<Option<magnus::Value>, Error> {
        let (mut lease, state) = Self::take(ruby, document)?;
        let mut state = match (mode.as_str(), state) {
            ("chunks", StreamState::Fresh(value)) => StreamState::Chunks((*value).into_chunks()),
            ("jsonl", StreamState::Fresh(value)) => StreamState::Jsonl((*value).into_jsonl()),
            ("tsv", StreamState::Fresh(value)) => StreamState::Tsv((*value).into_tsv(consistent)),
            ("chunks", state @ StreamState::Chunks(_))
            | ("jsonl", state @ StreamState::Jsonl(_))
            | ("tsv", state @ StreamState::Tsv(_)) => state,
            _ => return Err(misuse(ruby)),
        };
        let closed = Arc::clone(&document.owner.stream);
        let signal = Arc::clone(&document.owner.close_signal);
        let (state, row) = gvl::wait(
            ruby,
            "DocumentError",
            Arc::clone(&document.owner.runtime),
            async move {
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
            },
        )?;
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
        let (_lease, state) = Self::take(ruby, document)?;
        let StreamState::Fresh(value) = state else {
            return Err(misuse(ruby));
        };
        let closed = Arc::clone(&document.owner.stream);
        let signal = Arc::clone(&document.owner.close_signal);
        let result = gvl::wait(
            ruby,
            "DocumentError",
            Arc::clone(&document.owner.runtime),
            async move {
                tokio::select! {
                    result = (*value).json(limit) => result,
                    () = wait_closed(closed, signal) => Err(DocumentError::Transport),
                }
            },
        )?;
        result
            .map(|value| value.to_string())
            .map_err(|e| error(ruby, e))
    }
}

async fn wait_closed(state: Arc<Mutex<StreamState>>, signal: Arc<Notify>) {
    loop {
        let notified = signal.notified();
        tokio::pin!(notified);
        notified.as_mut().enable();
        if matches!(*state.lock().unwrap(), StreamState::Closed) {
            return;
        }
        notified.await;
    }
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
        loop {
            // Register before inspecting, so notify_waiters cannot be missed.
            let notified = self.notify.notified();
            tokio::pin!(notified);
            notified.as_mut().enable();
            if !matches!(*self.result.lock().unwrap(), UploadState::Pending) {
                return;
            }
            notified.await;
        }
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
    runtime: Arc<RuntimeOwner>,
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
pub(super) struct Upload {
    pid: u32,
    owner: ManuallyDrop<UploadOwner>,
}
impl Drop for Upload {
    fn drop(&mut self) {
        if self.pid == std::process::id() {
            // SAFETY: only the creator drops sockets/runtime/locks. A fork child
            // intentionally leaks inherited state rather than touching it.
            unsafe { ManuallyDrop::drop(&mut self.owner) };
        }
    }
}
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
        guard(ruby, engine.pid)?;
        let options = UploadOptions {
            transfer: Config::parse(ruby, &config)?,
            content_type,
            headers,
            content_length,
        };
        let client = engine.state.client.documents();
        Self::spawn(engine, None, move |source| async move {
            client.upload(&url, source, options).await
        })
    }
    /// Start a bounded upload task whose body is fed through a capacity-1 channel.
    /// `make` builds the transfer future from the owned source stream.
    pub(super) fn spawn<F, Fut>(
        engine: &Engine,
        document_id: Option<String>,
        make: F,
    ) -> Result<Self, Error>
    where
        F: FnOnce(UploadSource) -> Fut,
        Fut: std::future::Future<Output = Result<UploadResponse, DocumentError>> + Send + 'static,
    {
        let runtime = Arc::clone(&engine.state.runtime);
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
        let worker = runtime
            .runtime
            .as_ref()
            .expect("runtime alive")
            .spawn(async move {
                let result = match AssertUnwindSafe(work).catch_unwind().await {
                    Ok(result) => result,
                    Err(payload) => {
                        std::mem::forget(payload);
                        Err(DocumentError::Transport)
                    }
                };
                let mut state = target.result.lock().unwrap();
                if matches!(*state, UploadState::Pending) {
                    *state = UploadState::Ready(result);
                }
                drop(state);
                target.notify.notify_waiters();
            });
        let abort = worker.abort_handle();
        drop(worker);
        Ok(Self {
            pid: engine.pid,
            owner: ManuallyDrop::new(UploadOwner {
                runtime,
                document_id,
                sender: Mutex::new(Some(sender)),
                completion,
                abort,
            }),
        })
    }
    fn document_id(ruby: &Ruby, upload: &Self) -> Result<Option<String>, Error> {
        guard(ruby, upload.pid)?;
        Ok(upload.owner.document_id.clone())
    }
    fn completed(ruby: &Ruby, upload: &Self) -> Result<bool, Error> {
        guard(ruby, upload.pid)?;
        Ok(!matches!(
            *upload.owner.completion.result.lock().unwrap(),
            UploadState::Pending
        ))
    }
    fn push(ruby: &Ruby, upload: &Self, bytes: RString) -> Result<bool, Error> {
        guard(ruby, upload.pid)?;
        // SAFETY: bounded Ruby bytes copied under GVL; none escape into Tokio.
        let data = unsafe { bytes.as_slice() };
        if data.len() > 64 << 10 {
            return Err(error(ruby, DocumentError::InvalidConfig));
        }
        let data = Bytes::copy_from_slice(data);
        let sender = upload.owner.sender.lock().unwrap().as_ref().cloned();
        let sender = sender.ok_or_else(|| misuse(ruby))?;
        let completion = Arc::clone(&upload.owner.completion);
        gvl::wait(
            ruby,
            "DocumentError",
            Arc::clone(&upload.owner.runtime),
            async move {
                tokio::select! { biased;
                    () = completion.ready() => false,
                    permit = sender.reserve() => match permit { Ok(permit) => { permit.send(data); true }, Err(_) => false },
                }
            },
        )
    }
    fn finish(ruby: &Ruby, upload: &Self) -> Result<UploadParts, Error> {
        guard(ruby, upload.pid)?;
        let sender = upload.owner.sender.lock().unwrap().take();
        drop(sender);
        let completion = Arc::clone(&upload.owner.completion);
        let response = gvl::wait(
            ruby,
            "DocumentError",
            Arc::clone(&upload.owner.runtime),
            async move {
                completion.ready().await;
                match std::mem::replace(&mut *completion.result.lock().unwrap(), UploadState::Taken)
                {
                    UploadState::Ready(result) => result,
                    _ => Err(DocumentError::UploadSource),
                }
            },
        )?
        .map_err(|e| error(ruby, e))?;
        let truncated = response.body_truncated;
        let completed = Completed::new(Response {
            status: response.status,
            headers: headers(&response.headers),
            body: response.body,
        });
        Ok((
            completed.response.status,
            completed.response.headers,
            ruby.str_from_slice(&completed.response.body),
            completed.metadata,
            truncated,
        ))
    }
    fn close(ruby: &Ruby, upload: &Self) -> Result<(), Error> {
        guard(ruby, upload.pid)?;
        upload.owner.abort.abort();
        let mut state = upload.owner.completion.result.lock().unwrap();
        if matches!(*state, UploadState::Pending) {
            *state = UploadState::Ready(Err(DocumentError::UploadSource));
        }
        drop(state);
        upload.owner.completion.notify.notify_waiters();
        let sender = upload.owner.sender.lock().unwrap().take();
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
    document.define_method("error_body", method!(Document::error_body, 0))?;
    document.define_method("error_body_truncated?", method!(Document::truncated, 0))?;
    document.define_method("next_row", method!(Document::next, 2))?;
    document.define_method("json", method!(Document::json, 1))?;
    let upload = native.define_class("UploadHandle", ruby.class_object())?;
    upload.define_method("completed?", method!(Upload::completed, 0))?;
    upload.define_method("push", method!(Upload::push, 1))?;
    upload.define_method("finish", method!(Upload::finish, 0))?;
    upload.define_method("close", method!(Upload::close, 0))?;
    upload.define_method("document_id", method!(Upload::document_id, 0))?;
    // No public constructors: handles originate from an authenticated Engine pool.
    Ok(())
}
