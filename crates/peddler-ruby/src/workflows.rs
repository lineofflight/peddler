//! Document ID lifecycle helpers. Metadata, polling and transfer start run in Rust
//! under one deadline; Ruby wraps the owned outputs and feeds upload chunks.
use super::{Completed, Engine, ResponseParts, documents, gvl, native_error};
use documents::{Config, Document, Upload};
use magnus::{Error, RClass, RModule, Ruby, method, prelude::*};
use peddler::{
    documents::{Error as DocumentError, UploadOptions},
    workflows::{WaitOptions, WorkflowError},
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
            let raised = ruby
                .class_object()
                .const_get::<_, RModule>("Peddler")
                .and_then(|module| module.const_get::<_, RClass>("Response"))
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

#[derive(Clone, Copy)]
enum Kind {
    Report,
    Feed,
    Query,
}

fn download(
    ruby: &Ruby,
    engine: &Engine,
    kind: Kind,
    id: String,
    config: String,
) -> Result<Document, Error> {
    let state = engine.0.get(ruby)?;
    let options = Config::parse(ruby, &config)?;
    let workflows = state.client.workflows();
    let shared = state.shared;
    let download = gvl::wait(ruby, "WorkflowError", shared, async move {
        match kind {
            Kind::Report => workflows.download_report_document(&id, options).await,
            Kind::Feed => workflows.download_feed_document(&id, options).await,
            Kind::Query => workflows.download_query_document(&id, options).await,
        }
    })?
    .map_err(|error| workflow_error(ruby, error))?;
    Ok(Document::from_download(shared, download))
}
fn download_report(
    ruby: &Ruby,
    engine: &Engine,
    id: String,
    config: String,
) -> Result<Document, Error> {
    download(ruby, engine, Kind::Report, id, config)
}
fn download_feed(
    ruby: &Ruby,
    engine: &Engine,
    id: String,
    config: String,
) -> Result<Document, Error> {
    download(ruby, engine, Kind::Feed, id, config)
}
fn download_query(
    ruby: &Ruby,
    engine: &Engine,
    id: String,
    config: String,
) -> Result<Document, Error> {
    download(ruby, engine, Kind::Query, id, config)
}

fn wait(
    ruby: &Ruby,
    engine: &Engine,
    kind: Kind,
    id: String,
    interval: f64,
    timeout: f64,
) -> Result<ResponseParts, Error> {
    let state = engine.0.get(ruby)?;
    let invalid = || Error::new(ruby.exception_arg_error(), "invalid workflow configuration");
    let options = WaitOptions {
        interval: Duration::try_from_secs_f64(interval).map_err(|_| invalid())?,
        timeout: Duration::try_from_secs_f64(timeout).map_err(|_| invalid())?,
    };
    let workflows = state.client.workflows();
    let result = gvl::wait(ruby, "WorkflowError", state.shared, async move {
        match kind {
            Kind::Report => workflows
                .wait_for_report(&id, options)
                .await
                .map(|r| r.into_raw()),
            Kind::Feed => workflows
                .wait_for_feed(&id, options)
                .await
                .map(|r| r.into_raw()),
            Kind::Query => workflows
                .wait_for_query(&id, options)
                .await
                .map(|r| r.into_raw()),
        }
        .map(Completed::new)
    })?;
    let completed = result.map_err(|error| workflow_error(ruby, error))?;
    Ok(completed.into_parts(ruby))
}
fn wait_report(
    ruby: &Ruby,
    engine: &Engine,
    id: String,
    interval: f64,
    timeout: f64,
) -> Result<ResponseParts, Error> {
    wait(ruby, engine, Kind::Report, id, interval, timeout)
}
fn wait_feed(
    ruby: &Ruby,
    engine: &Engine,
    id: String,
    interval: f64,
    timeout: f64,
) -> Result<ResponseParts, Error> {
    wait(ruby, engine, Kind::Feed, id, interval, timeout)
}
fn wait_query(
    ruby: &Ruby,
    engine: &Engine,
    id: String,
    interval: f64,
    timeout: f64,
) -> Result<ResponseParts, Error> {
    wait(ruby, engine, Kind::Query, id, interval, timeout)
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

pub(super) fn init(ruby: &Ruby, peddler: RModule, engine: RClass) -> Result<(), Error> {
    let error = peddler.define_class(
        "WorkflowError",
        ruby.exception_standard_error().as_r_class(),
    )?;
    peddler.define_class("WorkflowTimeoutError", error)?;
    engine.define_method("download_report_document", method!(download_report, 2))?;
    engine.define_method("download_feed_document", method!(download_feed, 2))?;
    engine.define_method("download_query_document", method!(download_query, 2))?;
    engine.define_method("wait_for_report", method!(wait_report, 3))?;
    engine.define_method("wait_for_feed", method!(wait_feed, 3))?;
    engine.define_method("wait_for_query", method!(wait_query, 3))?;
    engine.define_method("start_feed_document_upload", method!(start_feed_upload, 3))?;
    Ok(())
}
