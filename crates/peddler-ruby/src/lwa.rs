//! Owned authorization-code work using the shared protected GVL executor.
use super::{RuntimeOwner, gvl};
use magnus::{Error, Exception, RModule, Ruby, function, method, prelude::*};
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

fn error(ruby: &Ruby, error: AuthError) -> Error {
    let name = match error {
        AuthError::InvalidConfig => "ArgumentError",
        AuthError::Timeout => "TimeoutError",
        AuthError::Transport => "TransportError",
        _ => "AuthenticationError",
    };
    let status = match error {
        AuthError::Rejected(status) => Some(status),
        _ => None,
    };
    marked_error(ruby, name, &error.to_string(), status)
}
fn marked_error(ruby: &Ruby, name: &str, message: &str, status: Option<u16>) -> Error {
    let exception = (|| -> Result<Exception, Error> {
        let class = if name == "ArgumentError" {
            ruby.exception_arg_error().as_r_class()
        } else {
            ruby.class_object()
                .const_get::<_, RModule>("Peddler")?
                .const_get::<_, RModule>("Native")?
                .const_get(name)?
        };
        let exception: Exception = if name == "AuthenticationError" {
            class.funcall("new", (message, status))?
        } else {
            class.funcall("new", (message,))?
        };
        let _: magnus::Value =
            exception.funcall("instance_variable_set", ("@peddler_native_lwa_error", true))?;
        Ok(exception)
    })();
    match exception {
        Ok(exception) => Error::from(exception),
        Err(error) => error,
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
            return Err(marked_error(
                ruby,
                "ForkError",
                "create a new client after fork",
                None,
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
        )
        .map_err(mark_wait_error)?;
        let tokens = result.map_err(|e| error(ruby, e))?;
        Ok((
            tokens.access_token,
            tokens.refresh_token,
            tokens.token_type,
            tokens.expires_in,
        ))
    }
}
fn mark_wait_error(error: Error) -> Error {
    // Captured Ruby exceptions and nonlocal jumps preserve their identity.
    let magnus::error::ErrorType::Error(class, message) = error.error_type() else {
        return error;
    };
    let marked = (|| -> Result<Exception, Error> {
        let exception: Exception = class.funcall("new", (message.as_ref(),))?;
        let _: magnus::Value =
            exception.funcall("instance_variable_set", ("@peddler_native_lwa_error", true))?;
        Ok(exception)
    })();
    match marked {
        Ok(exception) => Error::from(exception),
        Err(error) => error,
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
