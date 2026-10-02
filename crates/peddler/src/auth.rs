//! Login with Amazon token requests.
//!
//! Every call makes one HTTP request. Nothing is cached, refreshed or persisted:
//! the caller stores the tokens and passes an access token to the client.

use futures_util::StreamExt;
use reqwest::{Url, header::HeaderValue};
use std::{fmt, time::Duration};
use tokio::time::Instant;

mod lwa;
pub use lwa::{LwaClient, LwaTokens};

const BODY_LIMIT: usize = 64 * 1024;

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum AuthError {
    InvalidConfig,
    InvalidResponse,
    /// LWA answered outside 2xx. `code` is the `error` field of its reply, such as
    /// `invalid_client` or `invalid_grant`, when it is a short lowercase identifier.
    Rejected {
        status: u16,
        code: Option<String>,
    },
    Timeout,
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
    let (scheme, rest) = value.split_once("://").ok_or(AuthError::InvalidConfig)?;
    let authority = rest
        .split_once('/')
        .map_or(rest, |(authority, _)| authority);
    if !matches!(scheme, "https" | "http")
        || authority.is_empty()
        || authority.contains('@')
        || value
            .chars()
            .any(|c| c.is_whitespace() || c.is_control() || matches!(c, '\\' | '?' | '#'))
    {
        return Err(AuthError::InvalidConfig);
    }
    let url = Url::parse(value).map_err(|_| AuthError::InvalidConfig)?;
    let loopback = url.host_str().is_some_and(|host| {
        host == "localhost"
            || host
                .trim_matches(['[', ']'])
                .parse::<std::net::IpAddr>()
                .is_ok_and(|ip| ip.is_loopback())
    });
    if url.host_str().is_none()
        || (scheme == "http" && !loopback)
        || !url.username().is_empty()
        || url.password().is_some()
    {
        return Err(AuthError::InvalidConfig);
    }
    Ok(url)
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
    if error.is_timeout() {
        AuthError::Timeout
    } else {
        AuthError::Transport
    }
}
