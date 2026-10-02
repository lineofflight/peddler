//! Owned-data Ruby boundary. Only the blocking callback runs without the GVL.

use magnus::{Error, RModule, RString, Ruby, function, method, prelude::*, rb_sys::AsRawValue};
use peddler::{
    Client, ClientConfig, Request, Response,
    auth::{Credentials, RestrictedScope},
    policy::{PolicyConfig, RateLimit, RetryPolicy},
};
use std::collections::BTreeMap;
use std::{
    ffi::c_void,
    mem::ManuallyDrop,
    panic::{AssertUnwindSafe, catch_unwind},
    sync::{
        Arc,
        atomic::{AtomicBool, Ordering},
    },
    time::Duration,
};
use tokio::runtime::{Builder, Runtime};

type ErrorMetadata = (String, Option<String>, Option<String>);
type ResponseParts = (u16, Vec<(String, String)>, RString, Option<ErrorMetadata>);
struct Completed {
    response: Response,
    metadata: Option<ErrorMetadata>,
}
impl Completed {
    fn new(response: Response) -> Self {
        match response.error_for_status() {
            Ok(response) => Self {
                response,
                metadata: None,
            },
            Err(error) => {
                use peddler::api_error::ApiErrorKind::*;
                let kind = match error.kind {
                    Unauthorized => "unauthorized",
                    Forbidden => "forbidden",
                    NotFound => "not_found",
                    Throttled => "throttled",
                    Server => "server",
                    Client => "client",
                    UnexpectedStatus => "unexpected_status",
                };
                Self {
                    response: error.response,
                    metadata: Some((kind.into(), error.code, error.request_id)),
                }
            }
        }
    }
}

// Three-part manually constructed Ruby responses use a bounded owned helper.
// Network response metadata is computed by Completed outside the GVL instead.
fn response_metadata(
    status: u16,
    headers: Vec<(String, String)>,
    body: RString,
) -> Option<ErrorMetadata> {
    const LIMIT: usize = 64 * 1024;
    // SAFETY: this entrypoint holds the GVL, and copies before any Ruby call.
    let bytes = unsafe { body.as_slice() };
    let body = if bytes.len() <= LIMIT {
        bytes.to_vec()
    } else {
        Vec::new()
    };
    Completed::new(Response {
        status,
        headers,
        body,
    })
    .metadata
}

struct State {
    client: Client,
    runtime: Arc<RuntimeOwner>,
}
struct RuntimeOwner {
    runtime: Option<Runtime>,
}

impl Drop for RuntimeOwner {
    fn drop(&mut self) {
        if let Some(runtime) = self.runtime.take() {
            // GC must never wait on Tokio's blocking pool (e.g. DNS).
            runtime.shutdown_background();
        }
    }
}

#[magnus::wrap(class = "Peddler::Native::Engine", free_immediately)]
struct Engine {
    pid: u32,
    state: ManuallyDrop<Arc<State>>,
}

impl Drop for Engine {
    fn drop(&mut self) {
        if self.pid == std::process::id() {
            // SAFETY: this field is dropped exactly once, only in its creator
            // process. The child must leak all inherited state, including the
            // reqwest client: its destructor may touch inherited locks.
            unsafe { ManuallyDrop::drop(&mut self.state) };
        }
    }
}

fn native_error(ruby: &Ruby, name: &str, message: &str) -> Error {
    let class = ruby
        .class_object()
        .const_get::<_, RModule>("Peddler")
        .and_then(|module| module.const_get::<_, RModule>("Native"))
        .and_then(|module| module.const_get(name));
    match class {
        Ok(class) => Error::new(class, message.to_owned()),
        Err(error) => error,
    }
}

fn transport_error(ruby: &Ruby, error: peddler::Error) -> Error {
    match error {
        peddler::Error::InvalidRequest => Error::new(ruby.exception_arg_error(), "invalid request"),
        peddler::Error::Timeout => native_error(ruby, "TimeoutError", "request timed out"),
        peddler::Error::Transport => native_error(ruby, "TransportError", "transport failed"),
        peddler::Error::Authentication(auth) => {
            let status = match auth {
                peddler::auth::AuthError::Rejected(status) => Some(status),
                _ => None,
            };
            let exception = ruby
                .class_object()
                .const_get::<_, RModule>("Peddler")
                .and_then(|m| m.const_get::<_, RModule>("Native"))
                .and_then(|m| m.const_get::<_, magnus::RClass>("AuthenticationError"))
                .and_then(|c| {
                    c.funcall::<_, _, magnus::Exception>("new", ("authentication failed", status))
                });
            match exception {
                Ok(e) => Error::from(e),
                Err(e) => e,
            }
        }
    }
}

impl Engine {
    fn new(
        ruby: &Ruby,
        base_url: String,
        access_token: String,
        timeout: f64,
    ) -> Result<Self, Error> {
        let duration = Duration::try_from_secs_f64(timeout)
            .map_err(|_| Error::new(ruby.exception_arg_error(), "invalid timeout"))?;
        let client = Client::with_timeout(&base_url, &access_token, duration)
            .map_err(|error| transport_error(ruby, error))?;
        Self::from_client(ruby, client)
    }

    fn from_client(ruby: &Ruby, client: Client) -> Result<Self, Error> {
        let runtime = Builder::new_multi_thread()
            .worker_threads(1)
            .enable_all()
            .build()
            .map_err(|_| native_error(ruby, "TransportError", "runtime initialization failed"))?;
        Ok(Self {
            pid: std::process::id(),
            state: ManuallyDrop::new(Arc::new(State {
                client,
                runtime: Arc::new(RuntimeOwner {
                    runtime: Some(runtime),
                }),
            })),
        })
    }

    fn from_config(ruby: &Ruby, json: String) -> Result<Self, Error> {
        let config: Config = serde_json::from_str(&json)
            .map_err(|_| Error::new(ruby.exception_arg_error(), "invalid configuration"))?;
        let client = config
            .client()
            .map_err(|error| transport_error(ruby, error))?;
        Self::from_client(ruby, client)
    }

    fn restricted(ruby: &Ruby, engine: &Self, json: String) -> Result<Self, Error> {
        if engine.pid != std::process::id() {
            return Err(native_error(
                ruby,
                "ForkError",
                "create a new client after fork",
            ));
        }
        let scope: RestrictedScope = serde_json::from_str(&json)
            .map_err(|_| Error::new(ruby.exception_arg_error(), "invalid restricted scope"))?;
        let client = engine
            .state
            .client
            .restricted(scope)
            .map_err(|e| transport_error(ruby, e))?;
        Ok(Self {
            pid: engine.pid,
            state: ManuallyDrop::new(Arc::new(State {
                client,
                runtime: Arc::clone(&engine.state.runtime),
            })),
        })
    }

    fn request(
        ruby: &Ruby,
        engine: &Self,
        method: String,
        path: String,
        query: Vec<(String, String)>,
        body: Option<RString>,
    ) -> Result<ResponseParts, Error> {
        // SAFETY: the GVL is held; copy bytes before any Ruby call or GVL release.
        let body = body.map(|value| unsafe { value.as_slice().to_vec() });
        Self::execute(
            ruby,
            engine,
            Work::Raw {
                operation: "raw".into(),
                request: Request {
                    method,
                    path,
                    query,
                    body,
                },
            },
        )
    }

    fn request_with_operation(
        ruby: &Ruby,
        engine: &Self,
        operation: String,
        method: String,
        path: String,
        query: Vec<(String, String)>,
        body: Option<RString>,
    ) -> Result<ResponseParts, Error> {
        // SAFETY: the GVL is held; copy bytes before any Ruby call or GVL release.
        let body = body.map(|value| unsafe { value.as_slice().to_vec() });
        Self::execute(
            ruby,
            engine,
            Work::Raw {
                operation,
                request: Request {
                    method,
                    path,
                    query,
                    body,
                },
            },
        )
    }

    fn operation(
        ruby: &Ruby,
        engine: &Self,
        name: String,
        arguments: String,
    ) -> Result<ResponseParts, Error> {
        Self::execute(ruby, engine, Work::Operation { name, arguments })
    }

    fn execute(ruby: &Ruby, engine: &Self, work: Work) -> Result<ResponseParts, Error> {
        if engine.pid != std::process::id() {
            return Err(native_error(
                ruby,
                "ForkError",
                "create a new client after fork",
            ));
        }
        // Separate allocation: the unblock callback's shared AtomicBool reference
        // never aliases the run callback's mutable Invocation reference.
        let cancelled = Box::new(AtomicBool::new(false));
        let mut invocation = Box::new(Invocation {
            state: Arc::clone(&engine.state),
            work: Some(work),
            cancelled: &*cancelled,
            result: None,
        });
        let nil = ruby.qnil().as_raw();
        // Keep both boxes OUTSIDE protect: Ruby longjmp must not skip their Drop.
        magnus::rb_sys::protect(|| {
            // SAFETY: both allocations outlive this synchronous call. run and
            // unblock touch only owned Rust data. protect catches Ruby interrupts
            // raised while reacquiring the GVL, and returns a valid Ruby VALUE.
            unsafe {
                rb_sys::rb_thread_call_without_gvl(
                    Some(run),
                    (&mut *invocation as *mut Invocation).cast(),
                    Some(unblock),
                    (&*cancelled as *const AtomicBool).cast_mut().cast(),
                );
            }
            nil
        })?;
        match invocation.result.take() {
            Some(Ok(completed)) => Ok((
                completed.response.status,
                completed.response.headers,
                ruby.str_from_slice(&completed.response.body),
                completed.metadata,
            )),
            Some(Err(Failure::Transport(error))) => Err(transport_error(ruby, error)),
            Some(Err(Failure::Cancelled)) => {
                Err(native_error(ruby, "TransportError", "request cancelled"))
            }
            Some(Err(Failure::Panic)) | None => Err(native_error(
                ruby,
                "TransportError",
                "native request failed",
            )),
        }
    }
}

enum Failure {
    Transport(peddler::Error),
    Cancelled,
    Panic,
}

enum Work {
    Raw { operation: String, request: Request },
    Operation { name: String, arguments: String },
}

struct Invocation {
    state: Arc<State>,
    work: Option<Work>,
    cancelled: *const AtomicBool,
    result: Option<Result<Completed, Failure>>,
}

unsafe extern "C" fn unblock(data: *mut c_void) {
    // SAFETY: execute keeps the allocation alive until without_gvl returns.
    unsafe { &*data.cast::<AtomicBool>() }.store(true, Ordering::Relaxed);
}

unsafe extern "C" fn run(data: *mut c_void) -> *mut c_void {
    // SAFETY: only this callback accesses Invocation until without_gvl returns.
    let invocation = unsafe { &mut *data.cast::<Invocation>() };
    let outcome = catch_unwind(AssertUnwindSafe(|| {
        let work = invocation.work.take().expect("invocation runs once");
        // SAFETY: execute owns this separate allocation for the entire call.
        let cancelled = unsafe { &*invocation.cancelled };
        invocation.state.runtime.runtime.as_ref().expect("runtime alive").block_on(async {
            tokio::select! {
                result = async {
                    match work {
                        Work::Raw { operation, request } => invocation.state.client.execute_with_operation(&operation, request).await,
                        Work::Operation { name, arguments } => {
                            peddler::apis::execute(&invocation.state.client, &name, &arguments).await
                        }
                    }
                } => result.map(Completed::new).map_err(Failure::Transport),
                () = async {
                    while !cancelled.load(Ordering::Relaxed) {
                        tokio::time::sleep(Duration::from_millis(5)).await;
                    }
                } => Err(Failure::Cancelled),
            }
        })
    }));
    invocation.result = Some(match outcome {
        Ok(result) => result,
        Err(payload) => {
            // A custom panic payload's destructor could panic too. Never unwind
            // through the C callback; preserve only a sanitized failure marker.
            std::mem::forget(payload);
            Err(Failure::Panic)
        }
    });
    std::ptr::null_mut()
}

#[magnus::init(name = "peddler_native")]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let peddler = ruby.define_module("Peddler")?;
    let native = peddler.define_module("Native")?;
    let error = native.define_class(
        "TransportError",
        ruby.exception_standard_error().as_r_class(),
    )?;
    native.define_class("TimeoutError", error)?;
    native.define_class("ForkError", ruby.exception_standard_error().as_r_class())?;
    native.define_class(
        "AuthenticationError",
        ruby.exception_standard_error().as_r_class(),
    )?;
    native.define_singleton_method("response_metadata", function!(response_metadata, 3))?;
    let engine = native.define_class("Engine", ruby.class_object())?;
    engine.define_singleton_method("new", function!(Engine::new, 3))?;
    engine.define_singleton_method("from_config", function!(Engine::from_config, 1))?;
    engine.define_method("restricted", method!(Engine::restricted, 1))?;
    engine.define_method("request", method!(Engine::request, 4))?;
    engine.define_method(
        "request_with_operation",
        method!(Engine::request_with_operation, 5),
    )?;
    engine.define_method("operation", method!(Engine::operation, 2))?;
    Ok(())
}

#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Config {
    base_url: String,
    #[serde(default)]
    access_token: Option<String>,
    #[serde(default)]
    client_id: Option<String>,
    #[serde(default)]
    client_secret: Option<String>,
    #[serde(default)]
    refresh_token: Option<String>,
    #[serde(default)]
    scope: Option<String>,
    #[serde(default = "default_timeout")]
    timeout: f64,
    #[serde(default)]
    retries: u32,
    #[serde(default = "default_delay")]
    retry_delay: f64,
    #[serde(default = "default_timeout")]
    max_retry_delay: f64,
    #[serde(default)]
    rate_limits: BTreeMap<String, RateConfig>,
    #[serde(default = "default_lwa")]
    lwa_endpoint: String,
}
#[derive(serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct RateConfig {
    rate: f64,
    burst: u32,
}
fn default_timeout() -> f64 {
    30.0
}
fn default_delay() -> f64 {
    0.2
}
fn default_lwa() -> String {
    peddler::DEFAULT_LWA_ENDPOINT.into()
}
impl Config {
    fn client(self) -> Result<Client, peddler::Error> {
        let invalid = || peddler::Error::InvalidRequest;
        let credentials = match (
            self.access_token,
            self.client_id,
            self.client_secret,
            self.refresh_token,
            self.scope,
        ) {
            (Some(token), None, None, None, None) => Credentials::AccessToken(token),
            (None, Some(client_id), Some(client_secret), Some(refresh_token), None) => {
                Credentials::RefreshToken {
                    client_id,
                    client_secret,
                    refresh_token,
                }
            }
            (None, Some(client_id), Some(client_secret), None, Some(scope)) => {
                Credentials::ClientCredentials {
                    client_id,
                    client_secret,
                    scope,
                }
            }
            _ => return Err(invalid()),
        };
        let mut config = ClientConfig::new(self.base_url, credentials);
        config.timeout = Duration::try_from_secs_f64(self.timeout).map_err(|_| invalid())?;
        config.lwa_endpoint = self.lwa_endpoint;
        config.policy = PolicyConfig {
            retry: RetryPolicy {
                max_retries: self.retries,
                base_delay: Duration::try_from_secs_f64(self.retry_delay).map_err(|_| invalid())?,
                max_delay: Duration::try_from_secs_f64(self.max_retry_delay)
                    .map_err(|_| invalid())?,
            },
            rate_limits: self
                .rate_limits
                .into_iter()
                .map(|(key, value)| {
                    (
                        key,
                        RateLimit {
                            rate_per_second: value.rate,
                            burst: value.burst,
                        },
                    )
                })
                .collect(),
        };
        Client::with_config(config)
    }
}
