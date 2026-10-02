//! Login with Amazon grants on the shared runtime and pool, one request each.
use super::{Shared, documents::guard, gvl, native_error, shared};
use magnus::{Error, RModule, Ruby, function, method, prelude::*};
use peddler::auth::{AuthError, LwaClient};
use std::{mem::ManuallyDrop, time::Duration};

/// Access token, refresh token when LWA sends one, token type and lifetime in seconds.
type Tokens = (String, Option<String>, String, u64);

#[magnus::wrap(class = "Peddler::Native::LwaEngine", free_immediately)]
struct LwaEngine {
    pid: u32,
    shared: &'static Shared,
    client: ManuallyDrop<LwaClient>,
}
impl Drop for LwaEngine {
    fn drop(&mut self) {
        if self.pid == std::process::id() {
            // SAFETY: only the creator drops the client; fork children leak
            // inherited state rather than touching inherited locks.
            unsafe { ManuallyDrop::drop(&mut self.client) };
        }
    }
}

fn auth_error(ruby: &Ruby, error: AuthError) -> Error {
    let message = error.to_string();
    let (status, code) = match error {
        AuthError::Rejected { status, code } => (Some(status), code),
        _ => (None, None),
    };
    let class = ruby
        .class_object()
        .const_get::<_, RModule>("Peddler")
        .and_then(|m| m.const_get::<_, magnus::RClass>("AuthenticationError"));
    let arguments = (message, status, magnus::kwargs!("code" => code));
    match class.and_then(|c| c.funcall::<_, _, magnus::Exception>("new", arguments)) {
        Ok(e) => Error::from(e),
        Err(e) => e,
    }
}

pub(super) fn error(ruby: &Ruby, error: AuthError) -> Error {
    match error {
        AuthError::InvalidConfig => Error::new(ruby.exception_arg_error(), error.to_string()),
        AuthError::Timeout => native_error(ruby, "TimeoutError", &error.to_string()),
        AuthError::Transport => native_error(ruby, "TransportError", &error.to_string()),
        _ => auth_error(ruby, error),
    }
}

enum Grant {
    Code(String, Option<String>),
    Refresh(String),
    ClientCredentials(String),
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
        let shared = shared(ruby)?;
        let client =
            LwaClient::with_pool(&shared.pool, &client_id, &client_secret, &endpoint, timeout)
                .map_err(|e| error(ruby, e))?;
        Ok(Self {
            pid: std::process::id(),
            shared,
            client: ManuallyDrop::new(client),
        })
    }

    fn grant(ruby: &Ruby, engine: &Self, grant: Grant) -> Result<Tokens, Error> {
        // Check before reading any inherited Rust state.
        guard(ruby, engine.pid)?;
        let client = LwaClient::clone(&engine.client);
        let result = gvl::wait(ruby, "TransportError", engine.shared, async move {
            match grant {
                Grant::Code(code, redirect_uri) => {
                    client
                        .exchange_authorization_code(&code, redirect_uri.as_deref())
                        .await
                }
                Grant::Refresh(refresh_token) => client.refresh(&refresh_token).await,
                Grant::ClientCredentials(scope) => client.client_credentials(&scope).await,
            }
        })?;
        let tokens = result.map_err(|e| error(ruby, e))?;
        Ok((
            tokens.access_token,
            tokens.refresh_token,
            tokens.token_type,
            tokens.expires_in,
        ))
    }

    fn exchange(
        ruby: &Ruby,
        engine: &Self,
        code: String,
        redirect_uri: Option<String>,
    ) -> Result<Tokens, Error> {
        Self::grant(ruby, engine, Grant::Code(code, redirect_uri))
    }

    fn refresh(ruby: &Ruby, engine: &Self, refresh_token: String) -> Result<Tokens, Error> {
        Self::grant(ruby, engine, Grant::Refresh(refresh_token))
    }

    fn client_credentials(ruby: &Ruby, engine: &Self, scope: String) -> Result<Tokens, Error> {
        Self::grant(ruby, engine, Grant::ClientCredentials(scope))
    }
}
pub(super) fn init(ruby: &Ruby, native: RModule) -> Result<(), Error> {
    let engine = native.define_class("LwaEngine", ruby.class_object())?;
    engine.define_singleton_method("new", function!(LwaEngine::new, 4))?;
    engine.define_method(
        "exchange_authorization_code",
        method!(LwaEngine::exchange, 2),
    )?;
    engine.define_method("refresh", method!(LwaEngine::refresh, 1))?;
    engine.define_method(
        "client_credentials",
        method!(LwaEngine::client_credentials, 1),
    )?;
    Ok(())
}
