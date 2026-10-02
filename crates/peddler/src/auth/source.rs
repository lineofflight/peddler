//! An in-process token source: one access token kept in memory, refreshed a little
//! before it expires, with one refresh in flight however many callers ask.
//!
//! It serves one process. Several processes each refresh for themselves; a shared
//! cache needs a source of the caller's own.
use super::{AuthError, LwaClient, TokenSource};
use futures_util::{
    FutureExt,
    future::{BoxFuture, Shared},
};
use std::{
    sync::{Arc, Mutex},
    time::Duration,
};
use tokio::time::Instant;

#[derive(Clone)]
struct Token {
    value: String,
    refresh_at: Instant,
    expires_at: Instant,
}

type Flight = Shared<BoxFuture<'static, Result<Token, AuthError>>>;
#[derive(Default)]
struct Slot {
    token: Option<Token>,
    flight: Option<Flight>,
    generation: u64,
    waiters: usize,
}
// Cancel abandoned refresh work when its last caller leaves. Keep the shared
// flight while any waiter remains.
struct FlightLease {
    slot: Arc<Mutex<Slot>>,
    generation: u64,
}
impl Drop for FlightLease {
    fn drop(&mut self) {
        let abandoned = {
            let Ok(mut state) = self.slot.lock() else {
                return;
            };
            if state.generation != self.generation {
                return;
            }
            state.waiters -= 1;
            if state.waiters == 0 {
                state.flight.take()
            } else {
                None
            }
        };
        // Dropping a flight releases its socket. That cleanup must run without
        // holding this slot's mutex.
        drop(abandoned);
    }
}

#[derive(Clone)]
enum Grant {
    RefreshToken(String),
    Scope(String),
}

impl LwaClient {
    /// A source for a seller's access token that keeps it in this process: it returns
    /// the token while it is fresh and refreshes it through [`LwaClient::refresh`]
    /// otherwise. Callers that arrive during a refresh share its result, and a failure
    /// is not kept. Clones share the token.
    pub fn source_for_refresh_token(&self, refresh_token: &str) -> Result<TokenSource, AuthError> {
        if refresh_token.trim().is_empty() {
            return Err(AuthError::InvalidConfig);
        }
        Ok(self.source(Grant::RefreshToken(refresh_token.into())))
    }

    /// Like `source_for_refresh_token`, for the token of grantless operations.
    pub fn source_for_scope(&self, scope: &str) -> Result<TokenSource, AuthError> {
        if scope.trim().is_empty() {
            return Err(AuthError::InvalidConfig);
        }
        Ok(self.source(Grant::Scope(scope.into())))
    }

    fn source(&self, grant: Grant) -> TokenSource {
        let slot = Arc::new(Mutex::new(Slot::default()));
        let client = self.clone();
        TokenSource::new(move || {
            let (client, grant) = (client.clone(), grant.clone());
            cached(slot.clone(), move || {
                async move {
                    let start = Instant::now();
                    let tokens = match &grant {
                        Grant::RefreshToken(token) => client.refresh(token).await,
                        Grant::Scope(scope) => client.client_credentials(scope).await,
                    }?;
                    expiring_token(tokens.access_token, tokens.expires_in, start)
                }
                .boxed()
            })
        })
    }
}

async fn cached(
    slot: Arc<Mutex<Slot>>,
    make: impl FnOnce() -> BoxFuture<'static, Result<Token, AuthError>>,
) -> Result<String, AuthError> {
    let (flight, generation) = {
        let mut state = slot.lock().map_err(|_| AuthError::Transport)?;
        if let Some(token) = &state.token
            && Instant::now() < token.refresh_at
            && Instant::now() < token.expires_at
        {
            return Ok(token.value.clone());
        }
        if state.flight.is_none() {
            state.generation = state.generation.wrapping_add(1);
            state.flight = Some(make().shared());
            state.waiters = 0;
        }
        state.waiters += 1;
        (state.flight.as_ref().unwrap().clone(), state.generation)
    };
    let _lease = FlightLease {
        slot: slot.clone(),
        generation,
    };
    let result = flight.await;
    {
        let mut state = slot.lock().map_err(|_| AuthError::Transport)?;
        if generation == state.generation {
            state.flight = None;
            state.token = result.as_ref().ok().cloned();
        }
    }
    let token = result?;
    if Instant::now() >= token.expires_at {
        return Err(AuthError::InvalidResponse);
    }
    Ok(token.value)
}

/// The lifetime counts from the start of the refresh request. The token is refreshed
/// early by 60 seconds, or by a tenth of its lifetime when that is shorter.
fn expiring_token(value: String, seconds: u64, start: Instant) -> Result<Token, AuthError> {
    if seconds == 0 {
        return Err(AuthError::InvalidResponse);
    }
    let lifetime = Duration::from_secs(seconds);
    let expires_at = start
        .checked_add(lifetime)
        .ok_or(AuthError::InvalidResponse)?;
    let refresh_at = expires_at
        .checked_sub(Duration::from_secs(60).min(lifetime / 10))
        .ok_or(AuthError::InvalidResponse)?;
    if Instant::now() >= expires_at {
        return Err(AuthError::InvalidResponse);
    }
    Ok(Token {
        value,
        expires_at,
        refresh_at,
    })
}
