//! Document ID lifecycle helpers. Metadata, polling and transfer start run in Rust
//! under one deadline; Ruby wraps the owned outputs and feeds upload chunks.
use super::{Completed, Engine, ResponseParts, documents, gvl, native_error, peddler_const};
use documents::{Config, Document, Upload};
use magnus::{Error, RClass, Ruby, method, prelude::*};
use peddler::{
    documents::{Error as DocumentError, UploadOptions},
    workflows::{DocumentKind, WaitOptions, WorkflowError},
};
use std::time::Duration;

fn workflow_error(ruby: &Ruby, error: WorkflowError) -> Error {
    let message = error.to_string();
    match error {
        WorkflowError::InvalidConfig => Error::new(ruby.exception_arg_error(), message),
        WorkflowError::Request(error) => super::transport_error(ruby, error),
        WorkflowError::Http(response) => {
            let completed = Completed::new(response);
            if completed.metadata.is_none() {
                return native_error(ruby, "WorkflowError", &message);
            }
            // An HTTP error from a metadata lookup raises as any failed API response does.
            let parts = completed.into_parts(ruby);
            let raised = peddler_const::<RClass>(ruby, "Response")
                .and_then(|class| class.funcall::<_, _, magnus::Value>("from_parts", (parts,)));
            match raised {
                Ok(_) => native_error(ruby, "WorkflowError", &message),
                Err(error) => error,
            }
        }
        WorkflowError::Timeout => native_error(ruby, "WorkflowTimeoutError", &message),
        WorkflowError::Document(error) | WorkflowError::Upload { error, .. } => {
            documents::error(ruby, error)
        }
        _ => native_error(ruby, "WorkflowError", &message),
    }
}

/// The kind Ruby names: "report", "feed" or "query".
fn kind(ruby: &Ruby, name: &str) -> Result<DocumentKind, Error> {
    match name {
        "report" => Ok(DocumentKind::Report),
        "feed" => Ok(DocumentKind::Feed),
        "query" => Ok(DocumentKind::Query),
        _ => Err(Error::new(
            ruby.exception_arg_error(),
            "invalid workflow configuration",
        )),
    }
}

fn download(
    ruby: &Ruby,
    engine: &Engine,
    kind_name: String,
    id: String,
    config: String,
) -> Result<Document, Error> {
    let state = engine.0.get(ruby)?;
    let kind = kind(ruby, &kind_name)?;
    let options = Config::parse(ruby, &config)?;
    let workflows = state.client.workflows();
    let shared = state.shared;
    let download = gvl::wait(ruby, "WorkflowError", shared, async move {
        workflows.download(kind, &id, options).await
    })?
    .map_err(|error| workflow_error(ruby, error))?;
    Ok(Document::from_download(shared, download))
}

fn wait(
    ruby: &Ruby,
    engine: &Engine,
    kind_name: String,
    id: String,
    interval: f64,
    timeout: f64,
) -> Result<ResponseParts, Error> {
    let state = engine.0.get(ruby)?;
    let kind = kind(ruby, &kind_name)?;
    let invalid = || Error::new(ruby.exception_arg_error(), "invalid workflow configuration");
    let options = WaitOptions {
        interval: Duration::try_from_secs_f64(interval).map_err(|_| invalid())?,
        timeout: Duration::try_from_secs_f64(timeout).map_err(|_| invalid())?,
    };
    let workflows = state.client.workflows();
    let result = gvl::wait(ruby, "WorkflowError", state.shared, async move {
        workflows.wait(kind, &id, options).await.map(Completed::new)
    })?;
    let completed = result.map_err(|error| workflow_error(ruby, error))?;
    Ok(completed.into_parts(ruby))
}

/// Creates the feed document, then starts the bounded upload task. The Ruby source
/// is only read after this returns, so invalid metadata never consumes it.
fn start_feed_upload(
    ruby: &Ruby,
    engine: &Engine,
    content_type: String,
    config: String,
    content_length: Option<u64>,
) -> Result<Upload, Error> {
    let state = engine.0.get(ruby)?;
    let options = UploadOptions {
        transfer: Config::parse(ruby, &config)?,
        content_type: content_type.clone(),
        headers: Vec::new(),
        content_length,
    };
    let workflows = state.client.workflows();
    let create = options.clone();
    let target = gvl::wait(ruby, "WorkflowError", state.shared, async move {
        workflows.create_feed_document(&content_type, &create).await
    })?
    .map_err(|error| workflow_error(ruby, error))?;
    let id = target.document_id.clone();
    Upload::spawn(state.shared, Some(id), move |source| async move {
        match target.upload(source, options).await {
            Ok(uploaded) => Ok(uploaded.response),
            Err(WorkflowError::Upload { error, .. }) => Err(error),
            Err(_) => Err(DocumentError::Transport),
        }
    })
}

pub(super) fn init(engine: RClass) -> Result<(), Error> {
    engine.define_method("download_workflow_document", method!(download, 3))?;
    engine.define_method("wait_for", method!(wait, 4))?;
    engine.define_method("start_feed_document_upload", method!(start_feed_upload, 3))?;
    Ok(())
}
