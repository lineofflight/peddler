//! Owned-data Ruby boundary. Only the blocking callback runs without the GVL.

use magnus::{Error, RModule, RString, Ruby, function, method, prelude::*};
use peddler::{
    Client, ClientConfig, Request, Response,
    auth::{Credentials, RestrictedScope},
    policy::{PolicyConfig, RateLimit, RetryPolicy},
};
use std::collections::BTreeMap;
use std::{mem::ManuallyDrop, sync::Arc, time::Duration};

mod documents;
mod gvl;
mod lwa;
mod workflows;
use tokio::runtime::{Builder, Runtime};

/// Amazon's error code, request ID and message, for a response outside 2xx.
type ErrorMetadata = (Option<String>, Option<String>, Option<String>);
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
                let message = serde_json::from_slice::<serde_json::Value>(&error.response.body)
                    .ok()
                    .and_then(|value| {
                        value
                            .get("errors")?
                            .as_array()?
                            .first()?
                            .get("message")?
                            .as_str()
                            .map(str::to_owned)
                    });
                Self {
                    response: error.response,
                    metadata: Some((error.code, error.request_id, message)),
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
    // Kept so a view for another destination can be built without Ruby holding secrets.
    config: Config,
    scope: Option<RestrictedScope>,
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
        Duration::try_from_secs_f64(timeout)
            .map_err(|_| Error::new(ruby.exception_arg_error(), "invalid timeout"))?;
        Self::from_parsed(
            ruby,
            Config {
                base_url,
                access_token: Some(access_token),
                client_id: None,
                client_secret: None,
                refresh_token: None,
                scope: None,
                timeout,
                retries: 0,
                retry_delay: default_delay(),
                max_retry_delay: default_timeout(),
                rate_limits: BTreeMap::new(),
                lwa_endpoint: default_lwa(),
                user_agent: None,
            },
        )
    }

    fn from_parsed(ruby: &Ruby, config: Config) -> Result<Self, Error> {
        let client = config
            .client()
            .map_err(|error| transport_error(ruby, error))?;
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
                config,
                scope: None,
            })),
        })
    }

    fn from_config(ruby: &Ruby, json: String) -> Result<Self, Error> {
        let config: Config = serde_json::from_str(&json)
            .map_err(|_| Error::new(ruby.exception_arg_error(), "invalid configuration"))?;
        Self::from_parsed(ruby, config)
    }

    /// The same configuration and restricted scope against another origin. Token and
    /// rate limit state start fresh; the runtime is shared.
    fn with_base_url(ruby: &Ruby, engine: &Self, base_url: String) -> Result<Self, Error> {
        if engine.pid != std::process::id() {
            return Err(native_error(
                ruby,
                "ForkError",
                "create a new client after fork",
            ));
        }
        let mut config = engine.state.config.clone();
        config.base_url = base_url;
        let scope = engine.state.scope.clone();
        let client = config.client().and_then(|client| match scope.clone() {
            Some(scope) => client.restricted(scope),
            None => Ok(client),
        });
        Ok(Self {
            pid: engine.pid,
            state: ManuallyDrop::new(Arc::new(State {
                client: client.map_err(|error| transport_error(ruby, error))?,
                runtime: Arc::clone(&engine.state.runtime),
                config,
                scope,
            })),
        })
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
            .restricted(scope.clone())
            .map_err(|e| transport_error(ruby, e))?;
        Ok(Self {
            pid: engine.pid,
            state: ManuallyDrop::new(Arc::new(State {
                client,
                runtime: Arc::clone(&engine.state.runtime),
                config: engine.state.config.clone(),
                scope: Some(scope),
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
        let state = Arc::clone(&engine.state);
        let runtime = Arc::clone(&state.runtime);
        let result = gvl::wait(ruby, "TransportError", runtime, async move {
            match work {
                Work::Raw { operation, request } => {
                    state
                        .client
                        .execute_with_operation(&operation, request)
                        .await
                }
                Work::Operation { name, arguments } => {
                    peddler::apis::execute(&state.client, &name, &arguments).await
                }
            }
            .map(Completed::new)
        })?;
        match result {
            Ok(completed) => Ok((
                completed.response.status,
                completed.response.headers,
                ruby.str_from_slice(&completed.response.body),
                completed.metadata,
            )),
            Err(error) => Err(transport_error(ruby, error)),
        }
    }
}

enum Work {
    Raw { operation: String, request: Request },
    Operation { name: String, arguments: String },
}

#[magnus::init(name = "peddler_native")]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let peddler = ruby.define_module("Peddler")?;
    let native = peddler.define_module("Native")?;
    let error = peddler.define_class(
        "TransportError",
        ruby.exception_standard_error().as_r_class(),
    )?;
    peddler.define_class("TimeoutError", error)?;
    peddler.define_class("ForkError", ruby.exception_standard_error().as_r_class())?;
    peddler.define_class(
        "AuthenticationError",
        ruby.exception_standard_error().as_r_class(),
    )?;
    native.define_singleton_method("response_metadata", function!(response_metadata, 3))?;
    let engine = native.define_class("Engine", ruby.class_object())?;
    engine.define_singleton_method("new", function!(Engine::new, 3))?;
    engine.define_singleton_method("from_config", function!(Engine::from_config, 1))?;
    engine.define_method("with_base_url", method!(Engine::with_base_url, 1))?;
    engine.define_method("restricted", method!(Engine::restricted, 1))?;
    engine.define_method("request", method!(Engine::request, 4))?;
    engine.define_method(
        "request_with_operation",
        method!(Engine::request_with_operation, 5),
    )?;
    engine.define_method("operation", method!(Engine::operation, 2))?;
    documents::init(ruby, peddler, native, engine)?;
    workflows::init(ruby, peddler, engine)?;
    lwa::init(ruby, native)?;
    Ok(())
}

#[derive(Clone, serde::Deserialize)]
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
    /// How the gem identifies itself. Without one, requests carry the Rust crate's own.
    #[serde(default)]
    user_agent: Option<String>,
}
#[derive(Clone, serde::Deserialize)]
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
    fn client(&self) -> Result<Client, peddler::Error> {
        let config = self.clone();
        let invalid = || peddler::Error::InvalidRequest;
        let credentials = match (
            config.access_token,
            config.client_id,
            config.client_secret,
            config.refresh_token,
            config.scope,
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
        let mut client = ClientConfig::new(config.base_url, credentials);
        client.timeout = Duration::try_from_secs_f64(config.timeout).map_err(|_| invalid())?;
        client.lwa_endpoint = config.lwa_endpoint;
        client.user_agent = config.user_agent;
        client.policy = PolicyConfig {
            retry: RetryPolicy {
                max_retries: config.retries,
                base_delay: Duration::try_from_secs_f64(config.retry_delay)
                    .map_err(|_| invalid())?,
                max_delay: Duration::try_from_secs_f64(config.max_retry_delay)
                    .map_err(|_| invalid())?,
            },
            rate_limits: config
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
        Client::with_config(client)
    }
}
