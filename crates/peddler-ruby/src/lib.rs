//! Owned-data Ruby boundary. Only the blocking callback runs without the GVL.

use magnus::{Error, RModule, RString, Ruby, function, method, prelude::*};
use peddler::{
    AccessToken, Client, ClientConfig, Pool, Request, Response,
    auth::{AuthError, TokenSource},
    policy::RetryPolicy,
};
use std::{
    mem::ManuallyDrop,
    sync::{Arc, Mutex},
    time::Duration,
};

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

/// The Tokio runtime and the connection pool every client in a process shares.
struct Shared {
    runtime: Runtime,
    pool: Pool,
}

impl Shared {
    /// Leaked on purpose: it lives as long as its process, and a forked child must
    /// never drop the one it inherited.
    fn build(user_agent: &str) -> Option<&'static Self> {
        let runtime = Builder::new_multi_thread()
            .worker_threads(1)
            .enable_all()
            .build()
            .ok()?;
        let pool = Pool::with_user_agent(user_agent).ok()?;
        Some(Box::leak(Box::new(Self { runtime, pool })))
    }
}

// The process that built the shared state, and the state.
static SHARED: Mutex<Option<(u32, &'static Shared)>> = Mutex::new(None);

/// The shared state of the calling process, built on first use. After a fork the
/// child builds its own: the inherited runtime has no threads there and is never
/// touched again.
fn shared(ruby: &Ruby) -> Result<&'static Shared, Error> {
    let pid = std::process::id();
    let current = |slot: &Option<(u32, &'static Shared)>| match *slot {
        Some((owner, shared)) if owner == pid => Some(shared),
        _ => None,
    };
    // The lock is never held across a call into Ruby, so a fork never inherits it locked.
    let lock = || SHARED.lock().unwrap_or_else(|error| error.into_inner());
    if let Some(shared) = current(&lock()) {
        return Ok(shared);
    }
    let version: String = ruby
        .class_object()
        .const_get::<_, RModule>("Peddler")?
        .const_get("VERSION")?;
    // LWA and signed URLs get this. Ruby adds the host name for the Selling Partner API.
    let user_agent = format!("Peddler/{version} (Language=Ruby)");
    let built = {
        let mut slot = lock();
        current(&slot).or_else(|| {
            let built = Shared::build(&user_agent);
            if let Some(shared) = built {
                *slot = Some((pid, shared));
            }
            built
        })
    };
    built.ok_or_else(|| native_error(ruby, "TransportError", "runtime initialization failed"))
}

/// A light view: an origin, a token, a timeout and a retry policy on the shared pool.
struct State {
    client: Client,
    shared: &'static Shared,
    // Kept so a view with another origin or token can be built without Ruby holding secrets.
    config: Config,
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
        peddler::Error::Authentication(error) => lwa::error(ruby, error),
    }
}

impl Engine {
    fn build(ruby: &Ruby, shared: &'static Shared, config: Config) -> Result<Self, Error> {
        let client = config
            .client(&shared.pool)
            .map_err(|error| transport_error(ruby, error))?;
        Ok(Self {
            pid: std::process::id(),
            state: ManuallyDrop::new(Arc::new(State {
                client,
                shared,
                config,
            })),
        })
    }

    fn from_config(ruby: &Ruby, json: String) -> Result<Self, Error> {
        let config: Config = serde_json::from_str(&json)
            .map_err(|_| Error::new(ruby.exception_arg_error(), "invalid configuration"))?;
        Self::build(ruby, shared(ruby)?, config)
    }

    /// The same configuration with one change, on the same pool and runtime.
    fn view(ruby: &Ruby, engine: &Self, change: impl FnOnce(&mut Config)) -> Result<Self, Error> {
        documents::guard(ruby, engine.pid)?;
        let mut config = engine.state.config.clone();
        change(&mut config);
        Self::build(ruby, engine.state.shared, config)
    }

    fn with_base_url(ruby: &Ruby, engine: &Self, base_url: String) -> Result<Self, Error> {
        Self::view(ruby, engine, |config| config.base_url = base_url)
    }

    /// Without a token the view is a template: Ruby asks a token source before each
    /// request and sends it through a further view.
    fn with_access_token(
        ruby: &Ruby,
        engine: &Self,
        access_token: Option<String>,
    ) -> Result<Self, Error> {
        Self::view(ruby, engine, |config| config.access_token = access_token)
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
            Work::Raw(Request {
                method,
                path,
                query,
                body,
            }),
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
        documents::guard(ruby, engine.pid)?;
        let state = Arc::clone(&engine.state);
        let result = gvl::wait(ruby, "TransportError", state.shared, async move {
            match work {
                Work::Raw(request) => state.client.execute(request).await,
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
    Raw(Request),
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
    let engine = native.define_class("Engine", ruby.class_object())?;
    engine.define_singleton_method("from_config", function!(Engine::from_config, 1))?;
    engine.define_method("with_base_url", method!(Engine::with_base_url, 1))?;
    engine.define_method("with_access_token", method!(Engine::with_access_token, 1))?;
    engine.define_method("request", method!(Engine::request, 4))?;
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
    /// Absent when Ruby holds a token source, which is never called from Rust.
    access_token: Option<String>,
    timeout: f64,
    retries: u32,
    retry_delay: f64,
    max_retry_delay: f64,
    /// How the gem identifies itself to the Selling Partner API. Without one, requests
    /// carry the pool's.
    user_agent: Option<String>,
}
impl Config {
    fn client(&self, pool: &Pool) -> Result<Client, peddler::Error> {
        let seconds =
            |value| Duration::try_from_secs_f64(value).map_err(|_| peddler::Error::InvalidRequest);
        let token = match &self.access_token {
            Some(token) => AccessToken::Static(token.clone()),
            // A request on the template itself has no token to send and fails closed.
            None => TokenSource::new(|| async { Err(AuthError::InvalidConfig) }).into(),
        };
        let mut config = ClientConfig::new(self.base_url.clone(), token);
        config.timeout = seconds(self.timeout)?;
        config.retry = RetryPolicy {
            max_retries: self.retries,
            base_delay: seconds(self.retry_delay)?,
            max_delay: seconds(self.max_retry_delay)?,
        };
        config.user_agent = self.user_agent.clone();
        config.pool = Some(pool.clone());
        Client::with_config(config)
    }
}
