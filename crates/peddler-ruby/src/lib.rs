//! Owned-data Ruby boundary. Only the blocking callback runs without the GVL.

use magnus::{
    Error, RModule, RString, Ruby, TryConvert, Value, function, method, prelude::*, typed_data::Obj,
};
use peddler::{
    Client, ClientConfig, Pool, Request, Response,
    auth::{AuthError, TokenSource},
    policy::RetryPolicy,
};
use std::{
    sync::{Arc, Mutex},
    time::{Duration, Instant},
};

mod documents;
mod fork;
mod gvl;
mod lwa;
mod workflows;
use fork::ForkOwned;
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
            Err(error) => Self {
                response: error.response,
                metadata: Some((error.code, error.request_id, error.message)),
            },
        }
    }

    fn into_parts(self, ruby: &Ruby) -> ResponseParts {
        (
            self.response.status,
            self.response.headers,
            ruby.str_from_slice(&self.response.body),
            self.metadata,
        )
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
    let version: String = peddler_const(ruby, "VERSION")?;
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
struct Engine(ForkOwned<Arc<State>>);

/// The instance variable that holds an engine's token source, when it has one.
const TOKEN_SOURCE: &str = "@token_source";

/// A constant of the `Peddler` module.
fn peddler_const<T: TryConvert>(ruby: &Ruby, name: &str) -> Result<T, Error> {
    ruby.class_object()
        .const_get::<_, RModule>("Peddler")?
        .const_get(name)
}

fn native_error(ruby: &Ruby, name: &str, message: &str) -> Error {
    match peddler_const(ruby, name) {
        Ok(class) => Error::new(class, message.to_owned()),
        Err(error) => error,
    }
}

/// The `Peddler::Error` a response outside 2xx raises, as a failed API call does. None
/// for a response inside 2xx.
fn api_error(ruby: &Ruby, response: Response) -> Option<Error> {
    let completed = Completed::new(response);
    completed.metadata.as_ref()?;
    let parts = completed.into_parts(ruby);
    peddler_const::<magnus::RClass>(ruby, "Response")
        .and_then(|class| class.funcall::<_, _, Value>("from_parts", (parts,)))
        .err()
}

/// The standard reason phrase of a status code, if it has one.
fn status_reason(code: u16) -> Option<&'static str> {
    http::StatusCode::from_u16(code).ok()?.canonical_reason()
}

/// What a caller is told of an option or an argument the core refuses. The core says
/// only that it refuses, so each is checked apart from the rest. A message names the
/// option and the rule, never the value.
const TIMEOUT: &str = "timeout must be a positive number of seconds";
const BASE_URL: &str = "base_url must be an origin (https, or http on a loopback host) without credentials, a path or a query";
const ACCESS_TOKEN: &str = "invalid access token";
const METHOD: &str = "method must be an HTTP method";
const PATH: &str = "path must be an absolute path, percent-encoded, without a query or fragment";

fn argument_error(ruby: &Ruby, message: &'static str) -> Error {
    Error::new(ruby.exception_arg_error(), message)
}

/// A timeout in seconds as the core takes it: one a deadline can be set by.
fn timeout(seconds: f64) -> Result<Duration, &'static str> {
    Duration::try_from_secs_f64(seconds)
        .ok()
        .filter(|timeout| !timeout.is_zero() && Instant::now().checked_add(*timeout).is_some())
        .ok_or(TIMEOUT)
}

fn transport_error(ruby: &Ruby, error: peddler::Error) -> Error {
    match error {
        peddler::Error::InvalidRequest => Error::new(ruby.exception_arg_error(), "invalid request"),
        peddler::Error::Timeout => native_error(ruby, "TimeoutError", "request timed out"),
        peddler::Error::Authentication(error) => lwa::error(ruby, error),
        // A transport failure, and whatever the core names later.
        _ => native_error(ruby, "TransportError", "transport failed"),
    }
}

impl Engine {
    fn build(ruby: &Ruby, shared: &'static Shared, config: Config) -> Result<Self, Error> {
        let client = config
            .client(&shared.pool)
            .map_err(|message| argument_error(ruby, message))?;
        let state = Arc::new(State {
            client,
            shared,
            config,
        });
        Ok(Self(ForkOwned::new(fork::CLIENT, state)))
    }

    fn from_config(ruby: &Ruby, json: String) -> Result<Self, Error> {
        let config: Config = serde_json::from_str(&json)
            .map_err(|_| Error::new(ruby.exception_arg_error(), "invalid configuration"))?;
        Self::build(ruby, shared(ruby)?, config)
    }

    /// The same configuration with one change, on the same pool and runtime.
    fn view(ruby: &Ruby, engine: &Self, change: impl FnOnce(&mut Config)) -> Result<Self, Error> {
        let state = engine.0.get(ruby)?;
        let mut config = state.config.clone();
        change(&mut config);
        Self::build(ruby, state.shared, config)
    }

    /// Keeps the token source, if the engine has one.
    fn with_base_url(
        ruby: &Ruby,
        rb_self: Obj<Self>,
        base_url: String,
    ) -> Result<Obj<Self>, Error> {
        let view = ruby.obj_wrap(Self::view(ruby, &rb_self, |config| {
            config.base_url = base_url
        })?);
        if let Some(source) = rb_self.ivar_get::<_, Option<Value>>(TOKEN_SOURCE)? {
            view.ivar_set(TOKEN_SOURCE, source)?;
        }
        Ok(view)
    }

    fn with_access_token(ruby: &Ruby, engine: &Self, access_token: String) -> Result<Self, Error> {
        Self::view(ruby, engine, |config| {
            config.access_token = Some(access_token)
        })
    }

    /// A view without a token of its own that asks `source` before each call that sends
    /// one.
    fn with_token_source(
        ruby: &Ruby,
        rb_self: Obj<Self>,
        source: Value,
    ) -> Result<Obj<Self>, Error> {
        let view = ruby.obj_wrap(Self::view(ruby, &rb_self, |config| {
            config.access_token = None
        })?);
        view.ivar_set(TOKEN_SOURCE, source)?;
        Ok(view)
    }

    /// The client for one call. The fork guard runs first: a source is the caller's code
    /// and may use a socket the child inherited. Then the source, if the engine has one,
    /// is asked on this thread with the GVL held, and its token goes into a view of the
    /// client that the call drops.
    fn client(ruby: &Ruby, rb_self: Obj<Self>) -> Result<(Client, &'static Shared), Error> {
        let state = rb_self.0.get(ruby)?;
        let Some(source) = rb_self.ivar_get::<_, Option<Value>>(TOKEN_SOURCE)? else {
            return Ok((state.client.clone(), state.shared));
        };
        let token: Value = source.funcall("call", ())?;
        // Raises the fixed ArgumentError that a token given to the client gets.
        let token: String =
            peddler_const::<RModule>(ruby, "Native")?.funcall("access_token", (token,))?;
        let client = state
            .client
            .with_access_token(&token)
            .map_err(|_| argument_error(ruby, ACCESS_TOKEN))?;
        Ok((client, state.shared))
    }

    fn request(
        ruby: &Ruby,
        rb_self: Obj<Self>,
        method: String,
        path: String,
        query: Vec<(String, String)>,
        body: Option<RString>,
    ) -> Result<ResponseParts, Error> {
        if http::Method::from_bytes(method.as_bytes()).is_err() {
            return Err(argument_error(ruby, METHOD));
        }
        // SAFETY: the GVL is held; copy bytes before any Ruby call or GVL release.
        let body = body.map(|value| unsafe { value.as_slice().to_vec() });
        Self::execute(
            ruby,
            rb_self,
            Work::Raw(Request {
                method,
                path,
                query,
                headers: Vec::new(),
                body,
            }),
        )
    }

    fn operation(
        ruby: &Ruby,
        rb_self: Obj<Self>,
        name: String,
        arguments: String,
    ) -> Result<ResponseParts, Error> {
        Self::execute(ruby, rb_self, Work::Operation { name, arguments })
    }

    fn execute(ruby: &Ruby, rb_self: Obj<Self>, work: Work) -> Result<ResponseParts, Error> {
        let (client, shared) = Self::client(ruby, rb_self)?;
        // Its method was checked, so what the core refuses of a raw request is its path.
        let raw = matches!(work, Work::Raw(_));
        let result = gvl::wait(ruby, "TransportError", fork::CLIENT, shared, async move {
            match work {
                Work::Raw(request) => client.execute(request).await,
                Work::Operation { name, arguments } => {
                    peddler::apis::execute(&client, &name, &arguments).await
                }
            }
            .map(Completed::new)
        })?;
        match result {
            Ok(completed) => Ok(completed.into_parts(ruby)),
            Err(peddler::Error::InvalidRequest) if raw => Err(argument_error(ruby, PATH)),
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
    native.define_singleton_method("status_reason", function!(status_reason, 1))?;
    let engine = native.define_class("Engine", ruby.class_object())?;
    engine.define_singleton_method("from_config", function!(Engine::from_config, 1))?;
    engine.define_method("with_base_url", method!(Engine::with_base_url, 1))?;
    engine.define_method("with_access_token", method!(Engine::with_access_token, 1))?;
    engine.define_method("with_token_source", method!(Engine::with_token_source, 1))?;
    engine.define_method("request", method!(Engine::request, 4))?;
    engine.define_method("operation", method!(Engine::operation, 2))?;
    documents::init(ruby, native, engine)?;
    workflows::init(engine)?;
    lwa::init(ruby, native)?;
    Ok(())
}

#[derive(Clone, serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Config {
    base_url: String,
    /// Absent when the engine asks a token source before each call.
    access_token: Option<String>,
    timeout: f64,
    retries: u32,
    /// How the gem identifies itself to the Selling Partner API. Without one, requests
    /// carry the pool's.
    user_agent: Option<String>,
}
impl Config {
    /// The client, or what to tell the caller of the option the core refuses.
    fn client(&self, pool: &Pool) -> Result<Client, &'static str> {
        // A request on the template itself has no token to send and fails closed.
        let template = TokenSource::new(|| async { Err(AuthError::InvalidConfig) });
        let mut config = ClientConfig::new(self.base_url.clone(), template);
        config.timeout = timeout(self.timeout)?;
        config.retry = RetryPolicy {
            max_retries: self.retries,
        };
        config.user_agent = self.user_agent.clone();
        config.pool = Some(pool.clone());
        // Ruby checked the retries, and a token is checked below, which leaves the base URL.
        let client = Client::with_config(config).map_err(|_| BASE_URL)?;
        match &self.access_token {
            Some(token) => client.with_access_token(token).map_err(|_| ACCESS_TOKEN),
            None => Ok(client),
        }
    }
}
