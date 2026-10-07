//! Login with Amazon token requests.
//!
//! Every call on [`LwaClient`] makes one HTTP request and keeps nothing: the caller
//! stores the tokens and passes an access token, or a [`TokenSource`], to the client.
//! `LwaClient::source_for_refresh_token` is an optional source that keeps one token
//! in this process.

use crate::url;
use futures_util::StreamExt;
use reqwest::{Url, header::HeaderValue};
use std::{fmt, future::Future, pin::Pin, sync::Arc, time::Duration};
use tokio::time::Instant;

mod lwa;
mod source;
pub use lwa::{LwaClient, LwaTokens};

type TokenFuture = Pin<Box<dyn Future<Output = Result<String, AuthError>> + Send>>;

/// Supplies an access token on request. A client built with one asks it before every
/// attempt and keeps nothing it returns: caching and refreshing belong to the source.
/// Clones are the same source.
#[derive(Clone)]
pub struct TokenSource(Arc<dyn Fn() -> TokenFuture + Send + Sync>);

impl TokenSource {
    /// A source from a function that returns a token every time it is called.
    pub fn new<F, Fut>(source: F) -> Self
    where
        F: Fn() -> Fut + Send + Sync + 'static,
        Fut: Future<Output = Result<String, AuthError>> + Send + 'static,
    {
        Self(Arc::new(move || Box::pin(source())))
    }

    /// Asks the source for a token.
    pub async fn token(&self) -> Result<String, AuthError> {
        (self.0)().await
    }
}

impl fmt::Debug for TokenSource {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("TokenSource").finish_non_exhaustive()
    }
}

const BODY_LIMIT: usize = 64 * 1024;

/// Why a token request or a token source failed. It keeps nothing of a credential,
/// a token or a response body.
#[derive(Clone, Debug, PartialEq, Eq)]
#[non_exhaustive]
pub enum AuthError {
    /// A credential, an argument, the endpoint or the timeout was refused before any
    /// request.
    InvalidConfig,
    /// LWA answered inside 2xx without a token that can be used, or a source returned
    /// one that can't be sent.
    InvalidResponse,
    /// LWA answered outside 2xx. `code` is the `error` field of its reply, such as
    /// `invalid_client` or `invalid_grant`, when it is a short lowercase identifier.
    Rejected {
        /// The HTTP status of the reply.
        status: u16,
        /// What LWA names as the problem.
        code: Option<String>,
    },
    /// The request took longer than the timeout.
    Timeout,
    /// The request couldn't be sent or its reply couldn't be read.
    Transport,
}

impl fmt::Display for AuthError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidConfig => f.write_str("invalid authentication configuration"),
            Self::InvalidResponse => f.write_str("invalid authentication response"),
            Self::Rejected { status, .. } => write!(f, "authentication rejected ({status})"),
            Self::Timeout => f.write_str("authentication timed out"),
            Self::Transport => f.write_str("authentication transport failed"),
        }
    }
}
impl std::error::Error for AuthError {}

/// HTTPS, or HTTP to a loopback host. No userinfo, query or fragment.
fn endpoint(value: &str) -> Result<Url, AuthError> {
    url::parse(value, &['?'])
        .filter(|(scheme, endpoint)| {
            *scheme == "https" || *scheme == "http" && url::is_loopback(endpoint)
        })
        .map(|(_, endpoint)| endpoint)
        .ok_or(AuthError::InvalidConfig)
}

/// A token must be usable as a header value.
fn check_token(value: &str) -> Result<(), AuthError> {
    if value.trim().is_empty() || HeaderValue::from_str(value).is_err() {
        return Err(AuthError::InvalidResponse);
    }
    Ok(())
}

/// The lifetime counts from the start of the request and must not have passed.
fn check_lifetime(seconds: u64, start: Instant) -> Result<(), AuthError> {
    if seconds == 0 {
        return Err(AuthError::InvalidResponse);
    }
    let expires_at = start
        .checked_add(Duration::from_secs(seconds))
        .ok_or(AuthError::InvalidResponse)?;
    if Instant::now() >= expires_at {
        return Err(AuthError::InvalidResponse);
    }
    Ok(())
}

async fn read_response<T: serde::de::DeserializeOwned>(
    response: reqwest::Response,
) -> Result<T, AuthError> {
    let status = response.status();
    if !status.is_success() {
        // Nothing else of a rejection is kept: not the description, not the body.
        let code = read_body(response).await.ok().and_then(error_code);
        return Err(AuthError::Rejected {
            status: status.as_u16(),
            code,
        });
    }
    let body = read_body(response).await?;
    serde_json::from_slice(&body).map_err(|_| AuthError::InvalidResponse)
}

async fn read_body(response: reqwest::Response) -> Result<Vec<u8>, AuthError> {
    if response
        .content_length()
        .is_some_and(|size| size > BODY_LIMIT as u64)
    {
        return Err(AuthError::InvalidResponse);
    }
    let mut body = Vec::new();
    let mut stream = response.bytes_stream();
    while let Some(chunk) = stream.next().await {
        let chunk = chunk.map_err(transport)?;
        if chunk.len() > BODY_LIMIT - body.len() {
            return Err(AuthError::InvalidResponse);
        }
        body.extend_from_slice(&chunk);
    }
    Ok(body)
}

/// The `error` field of an OAuth error reply: a fixed vocabulary, not a secret.
fn error_code(body: Vec<u8>) -> Option<String> {
    #[derive(serde::Deserialize)]
    struct Rejection {
        error: String,
    }
    let code = serde_json::from_slice::<Rejection>(&body).ok()?.error;
    let plain = code
        .bytes()
        .all(|byte| byte.is_ascii_lowercase() || byte == b'_');
    ((1..=40).contains(&code.len()) && plain).then_some(code)
}

fn transport(error: reqwest::Error) -> AuthError {
    crate::classify(error, AuthError::Timeout, AuthError::Transport)
}
