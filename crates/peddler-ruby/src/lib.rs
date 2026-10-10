//! Owned-data Ruby boundary. Only the blocking callback runs without the GVL.

use magnus::{
    Error, RModule, RString, Ruby, TryConvert, Value, function, method, prelude::*, typed_data::Obj,
};
use peddler::{
    Client, ClientConfig, Pool, Request, Response, auth::TokenSource, policy::RetryPolicy,
};
use std::{
    sync::{
        Arc,
        atomic::{AtomicPtr, Ordering},
    },
    time::{Duration, Instant},
};

mod documents;
mod fork;
mod gvl;
mod hook;
mod lwa;
mod workflows;
use fork::ForkOwned;
use hook::Responder;
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
    fn build(user_agent: &str) -> Option<Self> {
        let runtime = Builder::new_multi_thread()
            .worker_threads(1)
            .enable_all()
            .build()
            .ok()?;
        let pool = Pool::with_user_agent(user_agent)
            .ok()?
            .with_interceptor(hook::Hook);
        Some(Self { runtime, pool })
    }
}

// The process that built the shared state, and the state. What is stored here is leaked:
// it lives as long as its process, and a forked child must never drop the one it
// inherited. The slot is swapped whole and there is no lock: on Ruby 3.3 and 3.4 another
// Ractor can fork while this one is in `shared`, and a lock held by a thread that the
// child doesn't have would never be released there.
static SHARED: AtomicPtr<(u32, Shared)> = AtomicPtr::new(std::ptr::null_mut());

/// The shared state of the calling process, built on first use. After a fork the
/// child builds its own: the inherited runtime has no threads there and is never
/// touched again.
fn shared(ruby: &Ruby) -> Result<&'static Shared, Error> {
    let pid = std::process::id();
    let current = |slot: *mut (u32, Shared)| -> Option<&'static Shared> {
        // SAFETY: what the slot points to was leaked and is never freed.
        match unsafe { slot.as_ref() } {
            Some((owner, shared)) if *owner == pid => Some(shared),
            _ => None,
        }
    };
    let mut seen = SHARED.load(Ordering::Acquire);
    if let Some(shared) = current(seen) {
        return Ok(shared);
    }
    let version: String = peddler_const(ruby, "VERSION")?;
    // LWA and signed URLs get this. Ruby adds the host name for the Selling Partner API.
    let user_agent = format!("Peddler/{version} (Language=Ruby)");
    // Built outside the slot, so 2 Ractors that both find it empty both build.
    let Some(built) = Shared::build(&user_agent) else {
        return Err(native_error(
            ruby,
            "TransportError",
            "runtime initialization failed",
        ));
    };
    let mine = Box::into_raw(Box::new((pid, built)));
    loop {
        if let Some(shared) = current(seen) {
            // Another Ractor of this process stored its own first, and every client uses
            // that one. This one was never used: its runtime is idle and stops at once.
            // SAFETY: `mine` came from `Box::into_raw` above and was not stored.
            drop(unsafe { Box::from_raw(mine) });
            return Ok(shared);
        }
        match SHARED.compare_exchange(seen, mine, Ordering::AcqRel, Ordering::Acquire) {
            // SAFETY: it is stored now, and so never freed.
            Ok(_) => return Ok(unsafe { &(*mine).1 }),
            Err(now) => seen = now,
        }
    }
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

    /// A view without a token of its own that asks `source` before each attempt that
    /// sends one.
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

    /// The client for one call, and what answers its questions (see `hook`), if it asks
    /// any. The fork guard runs first: a source is the caller's code and may use a socket
    /// the child inherited. A source is then asked before each attempt, as the crate asks
    /// its own `TokenSource`: on this thread with the GVL held, between passes of the
    /// call, and inside the timeout of the attempt.
    fn client(ruby: &Ruby, rb_self: Obj<Self>) -> Result<Call, Error> {
        let state = rb_self.0.get(ruby)?;
        let source = rb_self.ivar_get::<_, Option<Value>>(TOKEN_SOURCE)?;
        let responder = Responder::new(ruby, source)?;
        Ok((state.client.clone(), state.shared, responder))
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

    /// `rate_limit` is the rate of this call for the wait after a 429, in place of the
    /// documented one. Ruby checked it, and passes the documented one by default.
    fn operation(
        ruby: &Ruby,
        rb_self: Obj<Self>,
        name: String,
        arguments: String,
        rate_limit: Option<f64>,
    ) -> Result<ResponseParts, Error> {
        let work = Work::Operation {
            name,
            arguments,
            rate_limit,
        };
        Self::execute(ruby, rb_self, work)
    }

    fn execute(ruby: &Ruby, rb_self: Obj<Self>, work: Work) -> Result<ResponseParts, Error> {
        let (client, shared, mut responder) = Self::client(ruby, rb_self)?;
        // Its method was checked, so what the core refuses of a raw request is its path.
        let raw = matches!(work, Work::Raw(_));
        let future = async move {
            match work {
                Work::Raw(request) => client.execute(request).await,
                Work::Operation {
                    name,
                    arguments,
                    rate_limit,
                } => {
                    let client = client.with_rate_limit(rate_limit)?;
                    peddler::apis::execute(&client, &name, &arguments).await
                }
            }
            .map(Completed::new)
        };
        let result = gvl::asking(
            ruby,
            "TransportError",
            fork::CLIENT,
            shared,
            &mut responder,
            future,
        )?;
        match result {
            Ok(completed) => Ok(completed.into_parts(ruby)),
            Err(peddler::Error::InvalidRequest) if raw => Err(argument_error(ruby, PATH)),
            Err(error) => Err(transport_error(ruby, error)),
        }
    }
}

enum Work {
    Raw(Request),
    Operation {
        name: String,
        arguments: String,
        rate_limit: Option<f64>,
    },
}

/// A client, the shared state it runs on, and what answers the questions of the call.
type Call = (Client, &'static Shared, Option<Responder>);

#[magnus::init(name = "peddler_native")]
fn init(ruby: &Ruby) -> Result<(), Error> {
    // Every method defined below may be called from any Ractor. A handle belongs to the
    // Ractor that made it, as any object that isn't shareable does. What the handles of
    // several Ractors share is `SHARED` and what it holds, the runtime and the pool,
    // which are `Sync`, and the flag of the exchange hook, which only the main Ractor
    // sets (see `hook`). A class or a constant is looked up in Ruby on each use, but for
    // the 4 classes that magnus keeps, at the end of this function.
    // SAFETY: called while the extension loads, before it defines a method.
    unsafe { rb_sys::rb_ext_ractor_safe(true) };
    // The names of the instance variables that only this extension uses are interned
    // here, in the main Ractor. Ruby 3.3 and 3.4 can give a name 2 IDs when 2 Ractors are
    // the first to intern it, at once, and a source set under one is not found under the
    // other. `WebMock`, which a call looks for before anything defines it, is interned
    // too, as a precaution: a call interns the name to look it up, and the first call of
    // a Ractor could do so as the main Ractor parses the name for the first time. No run
    // has given it 2 IDs. Every other name the extension looks up is a constant or a
    // method that Ruby code defined before the extension could look it up.
    ruby.intern(TOKEN_SOURCE);
    ruby.intern(hook::HOOK);
    ruby.intern(hook::WEBMOCK);
    let peddler = ruby.define_module("Peddler")?;
    let native = peddler.define_module("Native")?;
    native.define_singleton_method("status_reason", function!(status_reason, 1))?;
    let engine = native.define_class("Engine", ruby.class_object())?;
    engine.define_singleton_method("from_config", function!(Engine::from_config, 1))?;
    engine.define_method("with_base_url", method!(Engine::with_base_url, 1))?;
    engine.define_method("with_access_token", method!(Engine::with_access_token, 1))?;
    engine.define_method("with_token_source", method!(Engine::with_token_source, 1))?;
    engine.define_method("request", method!(Engine::request, 4))?;
    engine.define_method("operation", method!(Engine::operation, 3))?;
    documents::init(ruby, native, engine)?;
    workflows::init(engine)?;
    lwa::init(ruby, native)?;
    hook::init(native)?;
    // magnus looks the class of a wrapped type up once and keeps it behind a lock. That
    // happens here, in the main Ractor, so that no two Ractors meet at the lock later:
    // one waiting there could not stop for a garbage collection the other began.
    <Engine as magnus::TypedData>::class(ruby);
    <documents::Document as magnus::TypedData>::class(ruby);
    <documents::Upload as magnus::TypedData>::class(ruby);
    <lwa::LwaEngine as magnus::TypedData>::class(ruby);
    Ok(())
}

#[derive(Clone, serde::Deserialize)]
#[serde(deny_unknown_fields)]
struct Config {
    base_url: String,
    /// Absent when the engine asks a token source before each attempt.
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
        // Without a token of its own the client asks Ruby for one before each attempt. An
        // engine that has no source to ask has no token to send and fails closed.
        let source = TokenSource::new(hook::token);
        let mut config = ClientConfig::new(self.base_url.clone(), source);
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
