//! Shared asynchronous SP-API transport. HTTP error statuses remain responses.

#[rustfmt::skip]
pub mod apis;
#[rustfmt::skip]
pub mod reports;
#[rustfmt::skip]
pub mod feeds;
#[rustfmt::skip]
pub mod notifications;
#[rustfmt::skip]
pub mod data_kiosk;

pub mod api_error;
pub mod auth;
pub mod documents;
pub mod pagination;
pub mod policy;
pub mod workflows;

mod operation;
mod url;
pub use operation::{DecodeError, TypedResponse};

use auth::{AuthError, TokenSource};
use policy::RetryPolicy;
use reqwest::{Method, Url, header::HeaderValue};
use std::{future::Future, time::Duration};

pub const DEFAULT_LWA_ENDPOINT: &str = "https://api.amazon.com/auth/o2/token";

/// One HTTP connection pool. Clones share it, and so do the clients built on it.
#[derive(Clone)]
pub struct Pool {
    http: reqwest::Client,
}

impl std::fmt::Debug for Pool {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Pool").finish_non_exhaustive()
    }
}

impl Pool {
    pub fn new() -> Result<Self, Error> {
        Self::build(concat!(
            "Peddler/",
            env!("CARGO_PKG_VERSION"),
            " (Language=Rust)"
        ))
    }

    /// Replaces the crate's own User-Agent, for a wrapper that identifies itself.
    pub fn with_user_agent(user_agent: &str) -> Result<Self, Error> {
        HeaderValue::from_str(user_agent).map_err(|_| Error::InvalidRequest)?;
        Self::build(user_agent)
    }

    // Timeouts are set per request, so clients with different ones can share a pool.
    fn build(user_agent: &str) -> Result<Self, Error> {
        let http = reqwest::Client::builder()
            .redirect(reqwest::redirect::Policy::none())
            .retry(reqwest::retry::never())
            .no_gzip()
            .no_brotli()
            .no_deflate()
            .no_zstd()
            .user_agent(user_agent)
            .build()
            .map_err(|_| Error::Transport)?;
        Ok(Self { http })
    }
}

/// The access token a client sends: a value, or a source it asks before every attempt.
#[derive(Clone)]
pub enum AccessToken {
    Static(String),
    Source(TokenSource),
}

impl std::fmt::Debug for AccessToken {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(match self {
            Self::Static(_) => "Static([redacted])",
            Self::Source(_) => "Source",
        })
    }
}

impl From<&str> for AccessToken {
    fn from(token: &str) -> Self {
        Self::Static(token.into())
    }
}

impl From<&String> for AccessToken {
    fn from(token: &String) -> Self {
        Self::Static(token.clone())
    }
}

impl From<String> for AccessToken {
    fn from(token: String) -> Self {
        Self::Static(token)
    }
}

impl From<TokenSource> for AccessToken {
    fn from(source: TokenSource) -> Self {
        Self::Source(source)
    }
}

/// Construction performs no HTTP.
pub struct ClientConfig {
    pub base_url: String,
    pub access_token: AccessToken,
    /// One deadline for a call: every attempt, the body and the retry delays.
    pub timeout: Duration,
    pub retry: RetryPolicy,
    /// Sent to the Selling Partner API in place of the pool's User-Agent.
    pub user_agent: Option<String>,
    /// An existing pool to share. Without one the client creates its own.
    pub pool: Option<Pool>,
}
impl ClientConfig {
    pub fn new(base_url: impl Into<String>, access_token: impl Into<AccessToken>) -> Self {
        Self {
            base_url: base_url.into(),
            access_token: access_token.into(),
            timeout: Duration::from_secs(30),
            retry: RetryPolicy::default(),
            user_agent: None,
            pool: None,
        }
    }
}

/// A base URL and an access token on a connection pool. Clones share the pool.
/// The client never fetches, refreshes or caches a token itself.
#[derive(Clone)]
pub struct Client {
    http: reqwest::Client,
    origin: Url,
    token: Token,
    user_agent: Option<HeaderValue>,
    retry: RetryPolicy,
    timeout: Duration,
}

impl std::fmt::Debug for Client {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Client").finish_non_exhaustive()
    }
}

#[derive(Clone)]
enum Token {
    Static(HeaderValue),
    Source(TokenSource),
}

#[derive(Debug)]
pub struct Request {
    pub method: String,
    pub path: String,
    pub query: Vec<(String, String)>,
    /// Sent as given. A header the client or the transport sets is refused: `host`,
    /// `content-length`, `transfer-encoding`, `connection`, `content-type`, `accept`,
    /// `user-agent` and any `x-amz-*`.
    pub headers: Vec<(String, String)>,
    pub body: Option<Vec<u8>>,
}

#[derive(Debug)]
pub struct Response {
    pub status: u16,
    pub headers: Vec<(String, String)>,
    pub body: Vec<u8>,
}

#[derive(Debug, PartialEq, Eq)]
pub enum Error {
    InvalidRequest,
    Timeout,
    Transport,
    /// A token source failed or returned something that can't be sent.
    Authentication(AuthError),
}

impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(match self {
            Self::InvalidRequest => "invalid request",
            Self::Timeout => "request timed out",
            Self::Transport => "transport failed",
            Self::Authentication(_) => "authentication failed",
        })
    }
}

impl std::error::Error for Error {}

impl Client {
    pub fn new(base_url: &str, access_token: &str) -> Result<Self, Error> {
        Self::with_config(ClientConfig::new(base_url, access_token))
    }

    pub fn with_timeout(
        base_url: &str,
        access_token: &str,
        timeout: Duration,
    ) -> Result<Self, Error> {
        let mut config = ClientConfig::new(base_url, access_token);
        config.timeout = timeout;
        Self::with_config(config)
    }

    pub fn with_config(config: ClientConfig) -> Result<Self, Error> {
        let ClientConfig {
            base_url,
            access_token,
            timeout,
            retry,
            user_agent,
            pool,
        } = config;
        let (scheme, origin) = url::parse(&base_url, &['?']).ok_or(Error::InvalidRequest)?;
        // Check the original text for a path too: URL parsing normalizes dot segments
        // that callers must not supply as an origin. The access token is only ever
        // sent over HTTPS, or HTTP to a loopback host.
        if !matches!(scheme, "http" | "https")
            || base_url
                .splitn(4, '/')
                .nth(3)
                .is_some_and(|path| !path.is_empty())
            || origin.path() != "/"
            || (scheme == "http" && !url::is_loopback(&origin))
            // Zero, or too long for a deadline to be set by.
            || deadline(timeout).is_none()
        {
            return Err(Error::InvalidRequest);
        }
        let user_agent = user_agent
            .map(|value| HeaderValue::from_str(&value))
            .transpose()
            .map_err(|_| Error::InvalidRequest)?;
        retry.validate().map_err(|_| Error::InvalidRequest)?;
        let pool = match pool {
            Some(pool) => pool,
            None => Pool::new()?,
        };
        let token = match access_token {
            AccessToken::Static(token) => Token::Static(token_header(&token)?),
            AccessToken::Source(source) => Token::Source(source),
        };
        Ok(Self {
            http: pool.http,
            origin,
            token,
            user_agent,
            retry,
            timeout,
        })
    }

    /// A view with another access token that shares the pool and the policy: another
    /// seller, a rotated token, or a restricted data token for a few calls.
    pub fn with_access_token(&self, access_token: &str) -> Result<Self, Error> {
        let mut view = self.clone();
        view.token = Token::Static(token_header(access_token)?);
        Ok(view)
    }

    /// The token for one attempt. A source is asked every time and never retried.
    async fn token(&self) -> Result<HeaderValue, Error> {
        match &self.token {
            Token::Static(token) => Ok(token.clone()),
            Token::Source(source) => {
                let token = source.token().await.map_err(Error::Authentication)?;
                token_header(&token).map_err(|_| Error::Authentication(AuthError::InvalidResponse))
            }
        }
    }

    /// Runs `send` once per attempt, with that attempt's token, under one deadline
    /// that also covers asking a token source and the retry delays.
    async fn run<F, Fut>(&self, method: &str, send: F) -> Result<Response, Error>
    where
        F: Fn(HeaderValue) -> Fut,
        Fut: Future<Output = Result<Response, Error>>,
    {
        let deadline = deadline(self.timeout).ok_or(Error::InvalidRequest)?;
        tokio::time::timeout_at(deadline, async {
            let mut retry_index = 0;
            loop {
                let response = send(self.token().await?).await?;
                let Some(delay) =
                    self.retry
                        .retry_delay(method, response.status, &response.headers, retry_index)
                else {
                    return Ok(response);
                };
                if delay >= deadline.saturating_duration_since(tokio::time::Instant::now()) {
                    return Ok(response);
                }
                tokio::time::sleep(delay).await;
                retry_index += 1;
            }
        })
        .await
        .map_err(|_| Error::Timeout)?
    }

    /// What only the Selling Partner API receives: the token, the time of this
    /// attempt and a wrapper's User-Agent. Never LWA or signed URLs.
    fn authorize(&self, headers: &mut reqwest::header::HeaderMap, token: &HeaderValue) {
        headers.insert("x-amz-access-token", token.clone());
        headers.insert("x-amz-date", amz_date());
        if let Some(user_agent) = &self.user_agent {
            headers.insert(reqwest::header::USER_AGENT, user_agent.clone());
        }
    }

    pub async fn execute(&self, request: Request) -> Result<Response, Error> {
        self.execute_inner(request, false).await
    }

    /// Like `execute`, with the `Accept` header generated calls send.
    pub(crate) async fn execute_json(&self, request: Request) -> Result<Response, Error> {
        self.execute_inner(request, true).await
    }

    async fn execute_inner(&self, request: Request, accept_json: bool) -> Result<Response, Error> {
        if !request.path.starts_with('/')
            || request.path.starts_with("//")
            || request
                .path
                .chars()
                .any(|c| c.is_whitespace() || c.is_control() || matches!(c, '\\' | '?' | '#'))
            || !url::well_escaped(&request.path)
        {
            return Err(Error::InvalidRequest);
        }
        let method =
            Method::from_bytes(request.method.as_bytes()).map_err(|_| Error::InvalidRequest)?;
        let mut url = self.origin.clone();
        url.set_path(&request.path);
        if !request.query.is_empty() {
            url.query_pairs_mut().extend_pairs(&request.query);
        }
        let method_name = method.as_str().to_owned();
        let mut builder = self.http.request(method, url).timeout(self.timeout);
        if accept_json {
            builder = builder.header(reqwest::header::ACCEPT, "application/json");
        }
        if let Some(body) = request.body {
            builder = builder
                .header(reqwest::header::CONTENT_TYPE, "application/json")
                .body(body);
        }
        // An invalid name or value fails the build below.
        for (name, value) in &request.headers {
            if reserved(name) {
                return Err(Error::InvalidRequest);
            }
            builder = builder.header(name, value);
        }
        let buffered = builder.build().map_err(|_| Error::InvalidRequest)?;
        self.run(&method_name, |token| {
            let mut request = buffered.try_clone().expect("buffered body is repeatable");
            async move {
                self.authorize(request.headers_mut(), &token);
                let response = self
                    .http
                    .execute(request)
                    .await
                    .map_err(classify_transport)?;
                collect(response).await
            }
        })
        .await
    }
}

/// Whether the client or the transport sets this header itself.
fn reserved(name: &str) -> bool {
    let name = name.to_ascii_lowercase();
    name.starts_with("x-amz-")
        || matches!(
            name.as_str(),
            "host"
                | "content-length"
                | "transfer-encoding"
                | "connection"
                | "content-type"
                | "accept"
                | "user-agent"
        )
}

/// A timeout or a transport failure. The reqwest error itself is never kept: its
/// Display, Debug and source may contain URLs.
pub(crate) fn classify<E>(error: reqwest::Error, timeout: E, transport: E) -> E {
    if error.is_timeout() {
        timeout
    } else {
        transport
    }
}

fn classify_transport(error: reqwest::Error) -> Error {
    classify(error, Error::Timeout, Error::Transport)
}

/// The whole response, whatever its status.
async fn collect(response: reqwest::Response) -> Result<Response, Error> {
    let status = response.status().as_u16();
    let headers = response
        .headers()
        .iter()
        .map(|(name, value)| {
            (
                name.as_str().to_owned(),
                String::from_utf8_lossy(value.as_bytes()).into_owned(),
            )
        })
        .collect();
    let body = response.bytes().await.map_err(classify_transport)?.into();
    Ok(Response {
        status,
        headers,
        body,
    })
}

/// The instant `timeout` from now, unless the timeout is zero or too long to represent.
pub(crate) fn deadline(timeout: Duration) -> Option<tokio::time::Instant> {
    tokio::time::Instant::now()
        .checked_add(timeout)
        .filter(|_| !timeout.is_zero())
}

/// The time of an attempt, in the form Amazon's connection guide shows. Only requests
/// to the Selling Partner API carry it, never LWA or signed URLs.
pub(crate) fn amz_date() -> HeaderValue {
    let now = chrono::DateTime::<chrono::Utc>::from(std::time::SystemTime::now());
    HeaderValue::from_str(&now.format("%Y%m%dT%H%M%SZ").to_string()).expect("ASCII timestamp")
}

/// A token must be usable as a header value. It is never logged.
fn token_header(value: &str) -> Result<HeaderValue, Error> {
    if value.trim().is_empty() {
        return Err(Error::InvalidRequest);
    }
    let mut token = HeaderValue::from_str(value).map_err(|_| Error::InvalidRequest)?;
    token.set_sensitive(true);
    Ok(token)
}
