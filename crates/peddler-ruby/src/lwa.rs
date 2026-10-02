//! Login with Amazon grants on the shared runtime and pool, one request each.
use super::{ForkOwned, Shared, gvl, native_error, peddler_const, shared};
use magnus::{Error, RModule, Ruby, function, method, prelude::*};
use peddler::auth::{AuthError, LwaClient};
use std::time::Duration;

/// Access token, refresh token when LWA sends one, token type and lifetime in seconds.
type Tokens = (String, Option<String>, String, u64);

#[magnus::wrap(class = "Peddler::Native::LwaEngine", free_immediately)]
struct LwaEngine(ForkOwned<(&'static Shared, LwaClient)>);

fn auth_error(ruby: &Ruby, error: AuthError) -> Error {
    let message = error.to_string();
    let (status, code) = match error {
        AuthError::Rejected { status, code } => (Some(status), code),
        _ => (None, None),
    };
    let class = peddler_const::<magnus::RClass>(ruby, "AuthenticationError");
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
        Ok(Self(ForkOwned::new((shared, client))))
    }

    fn grant(ruby: &Ruby, engine: &Self, grant: Grant) -> Result<Tokens, Error> {
        let (shared, client) = engine.0.get(ruby)?;
        let client = client.clone();
        let result = gvl::wait(ruby, "TransportError", shared, async move {
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
