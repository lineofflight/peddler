//! Owned authorization-code work using the shared protected GVL executor.
use super::{RuntimeOwner, gvl, native_error};
use magnus::{Error, RModule, Ruby, function, method, prelude::*};
use peddler::auth::{AuthError, LwaClient};
use std::{mem::ManuallyDrop, sync::Arc, time::Duration};
use tokio::runtime::Builder;

struct State {
    client: LwaClient,
    runtime: Arc<RuntimeOwner>,
}
#[magnus::wrap(class = "Peddler::Native::LwaEngine", free_immediately)]
struct LwaEngine {
    pid: u32,
    state: ManuallyDrop<Arc<State>>,
}
impl Drop for LwaEngine {
    fn drop(&mut self) {
        if self.pid == std::process::id() {
            // SAFETY: only the creator drops sockets/runtime/locks; fork children
            // leak inherited state rather than touching inherited locks.
            unsafe { ManuallyDrop::drop(&mut self.state) };
        }
    }
}

fn auth_error(ruby: &Ruby, error: AuthError) -> Error {
    let message = error.to_string();
    let status = match error {
        AuthError::Rejected(status) => Some(status),
        _ => None,
    };
    let class = ruby
        .class_object()
        .const_get::<_, RModule>("Peddler")
        .and_then(|m| m.const_get::<_, RModule>("Native"))
        .and_then(|m| m.const_get::<_, magnus::RClass>("AuthenticationError"));
    match class.and_then(|c| c.funcall::<_, _, magnus::Exception>("new", (message, status))) {
        Ok(e) => Error::from(e),
        Err(e) => e,
    }
}

fn error(ruby: &Ruby, error: AuthError) -> Error {
    match error {
        AuthError::InvalidConfig => Error::new(ruby.exception_arg_error(), error.to_string()),
        AuthError::Timeout => native_error(ruby, "TimeoutError", &error.to_string()),
        AuthError::Transport => native_error(ruby, "TransportError", &error.to_string()),
        _ => auth_error(ruby, error),
    }
}
impl LwaEngine {
    fn new(
        ruby: &Ruby,
        client_id: String,
        client_secret: String,
        timeout: f64,
        endpoint: String,
    ) -> Result<Self, Error> {
        let timeout = Duration::try_from_secs_f64(timeout)
            .map_err(|_| error(ruby, AuthError::InvalidConfig))?;
        let client = LwaClient::with_config(&client_id, &client_secret, &endpoint, timeout)
            .map_err(|e| error(ruby, e))?;
        let runtime = Builder::new_multi_thread()
            .worker_threads(1)
            .enable_all()
            .build()
            .map_err(|_| error(ruby, AuthError::Transport))?;
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
    fn exchange(
        ruby: &Ruby,
        engine: &Self,
        code: String,
        redirect_uri: Option<String>,
    ) -> Result<(String, String, String, u64), Error> {
        // Check before reading any inherited Rust state, including Arc counts.
        if engine.pid != std::process::id() {
            return Err(native_error(
                ruby,
                "ForkError",
                "create a new client after fork",
            ));
        }
        let state = Arc::clone(&engine.state);
        let result = gvl::wait(
            ruby,
            "TransportError",
            Arc::clone(&state.runtime),
            async move {
                state
                    .client
                    .exchange_authorization_code(&code, redirect_uri.as_deref())
                    .await
            },
        )?;
        let tokens = result.map_err(|e| error(ruby, e))?;
        Ok((
            tokens.access_token,
            tokens.refresh_token,
            tokens.token_type,
            tokens.expires_in,
        ))
    }
}
pub(super) fn init(ruby: &Ruby, native: RModule) -> Result<(), Error> {
    let engine = native.define_class("LwaEngine", ruby.class_object())?;
    engine.define_singleton_method("new", function!(LwaEngine::new, 4))?;
    engine.define_method(
        "exchange_authorization_code",
        method!(LwaEngine::exchange, 2),
    )?;
    Ok(())
}
