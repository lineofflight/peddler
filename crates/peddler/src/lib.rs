//! A client for Amazon's Selling Partner API (SP-API).
//!
//! A [`Client`] sends the access token it is given over a connection pool that its
//! clones share. It never requests, refreshes or caches a token:
//! [`auth::LwaClient`] requests them. Each operation is an async function in a module
//! of [`apis`], with its parameters in a struct. The function returns once Amazon has
//! answered, whatever the status: an HTTP error status is a response, not an `Err`,
//! until [`Response::error_for_status`] is asked. A client retries nothing unless its
//! [`policy::RetryPolicy`] says how often.
//!
//! ```no_run
//! use peddler::{Client, apis::orders_v0};
//!
//! # async fn run() -> Result<(), Box<dyn std::error::Error>> {
//! let client = Client::new("https://sellingpartnerapi-eu.amazon.com", "Atza|...")?;
//! let params = orders_v0::GetOrdersParams::new(vec!["A1F83G8C2ARO7P".into()]);
//! let response = orders_v0::get_orders(&client, params).await?;
//! if response.raw.status == 200 {
//!     if let Some(payload) = response.json()?.payload {
//!         for order in payload.orders.iter() {
//!             println!("{} {:?}", order.amazon_order_id, order.order_status);
//!         }
//!     }
//! }
//! # Ok(())
//! # }
//! ```
//!
//! Beside the operations: [`pagination`] streams the pages of one, [`documents`]
//! transfers the documents of reports and feeds, and [`workflows`] waits for a report,
//! feed or query and fetches its document. [`reports`], [`feeds`], [`notifications`] and
//! [`data_kiosk`] hold the models of what those carry.
#![warn(missing_docs)]

#[allow(missing_docs)]
#[rustfmt::skip]
pub mod apis;
#[allow(missing_docs)]
#[rustfmt::skip]
pub mod reports;
#[allow(missing_docs)]
#[rustfmt::skip]
pub mod feeds;
#[allow(missing_docs)]
#[rustfmt::skip]
pub mod notifications;
#[allow(missing_docs)]
#[rustfmt::skip]
pub mod data_kiosk;

pub mod api_error;
pub mod auth;
pub mod documents;
#[doc(hidden)]
pub mod intercept;
pub mod pagination;
pub mod policy;
pub mod workflows;

mod operation;
mod url;
pub use operation::{DecodeError, TypedResponse};

use auth::{AuthError, TokenSource};
use policy::{Call, Outcome, RetryPolicy};
use reqwest::{Method, Url, header::HeaderValue};
use std::{future::Future, sync::Arc, time::Duration};

/// Amazon's Login with Amazon token endpoint.
pub const DEFAULT_LWA_ENDPOINT: &str = "https://api.amazon.com/auth/o2/token";

/// One HTTP connection pool. Clones share it, and so do the clients built on it.
#[derive(Clone)]
pub struct Pool {
    http: reqwest::Client,
    /// What a request without a User-Agent of its own is sent with.
    user_agent: HeaderValue,
    interceptor: Option<Arc<dyn intercept::Interceptor>>,
}

impl std::fmt::Debug for Pool {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Pool").finish_non_exhaustive()
    }
}

impl Pool {
    /// A pool that sends the crate's own User-Agent.
    pub fn new() -> Result<Self, Error> {
        Self::with_user_agent(concat!(
            "Peddler/",
            env!("CARGO_PKG_VERSION"),
            " (Language=Rust)"
        ))
    }

    /// Replaces the crate's own User-Agent, for a wrapper that identifies itself.
    pub fn with_user_agent(user_agent: &str) -> Result<Self, Error> {
        let user_agent = HeaderValue::from_str(user_agent).map_err(|_| Error::InvalidRequest)?;
        // Timeouts are set per request, so clients with different ones can share a pool.
        let http = reqwest::Client::builder()
            .redirect(reqwest::redirect::Policy::none())
            .retry(reqwest::retry::never())
            .no_gzip()
            .no_brotli()
            .no_deflate()
            .no_zstd()
            .user_agent(user_agent.clone())
            .build()
            .map_err(|_| Error::Transport)?;
        Ok(Self {
            http,
            user_agent,
            interceptor: None,
        })
    }
}

/// The access token a client sends: a value, or a source it asks before every attempt.
#[derive(Clone)]
pub enum AccessToken {
    /// A token, sent as it is until the client is replaced.
    Static(String),
    /// A source of tokens, which owns caching and refreshing.
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

/// What a client is built from. Construction performs no HTTP.
pub struct ClientConfig {
    /// The origin of the selling region, without a path: HTTPS, or HTTP on a loopback
    /// host.
    pub base_url: String,
    /// The token to send, or its source.
    pub access_token: AccessToken,
    /// The limit of each attempt: asking a token source, the request and the body.
    /// The waits between the attempts of a retried call are not counted.
    pub timeout: Duration,
    /// How often a throttled or failed call is retried. The default is never.
    pub retry: RetryPolicy,
    /// Sent to the Selling Partner API in place of the pool's User-Agent.
    pub user_agent: Option<String>,
    /// An existing pool to share. Without one the client creates its own.
    pub pool: Option<Pool>,
}
impl ClientConfig {
    /// A configuration that allows an attempt 30 seconds, with no retries and a pool of
    /// its own.
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
    pool: Pool,
    origin: Url,
    token: Token,
    user_agent: Option<HeaderValue>,
    retry: RetryPolicy,
    timeout: Duration,
    /// Whether the origin is Amazon's sandbox, where a 429 has a wait of its own.
    sandbox: bool,
    /// The rate a view was given in place of the documented ones, which may be none.
    rate_limit: Option<Option<f64>>,
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

/// A call the crate has no function for, sent with [`Client::execute`].
#[derive(Debug)]
pub struct Request {
    /// The HTTP method, such as `GET`.
    pub method: String,
    /// The absolute path, percent-encoded, without a query or a fragment.
    pub path: String,
    /// The query parameters, encoded when they are sent.
    pub query: Vec<(String, String)>,
    /// Sent as given. A header the client or the transport sets is refused: `host`,
    /// `content-length`, `transfer-encoding`, `connection`, `content-type`, `accept`,
    /// `user-agent` and any `x-amz-*`.
    pub headers: Vec<(String, String)>,
    /// A JSON body, sent as it is with `Content-Type: application/json`.
    pub body: Option<Vec<u8>>,
}

/// What Amazon answered, whatever the status.
#[derive(Debug)]
pub struct Response {
    /// The HTTP status.
    pub status: u16,
    /// The headers, their names in lowercase. A header that repeats has a pair for
    /// each value.
    pub headers: Vec<(String, String)>,
    /// The body as it arrived.
    pub body: Vec<u8>,
}

/// Why a call got no response. It keeps no URL, token or body.
#[derive(Debug, PartialEq, Eq)]
#[non_exhaustive]
pub enum Error {
    /// The client was given something it can't use or send: a base URL, a token, a
    /// timeout, a rate, a path, a header or an argument.
    InvalidRequest,
    /// The last attempt took longer than the client's timeout.
    Timeout,
    /// The request couldn't be sent or the response couldn't be read.
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
    /// A client for the endpoint of a selling region that sends this access token,
    /// allows an attempt 30 seconds and never retries.
    pub fn new(base_url: &str, access_token: &str) -> Result<Self, Error> {
        Self::with_config(ClientConfig::new(base_url, access_token))
    }

    /// Like `new`, with another timeout for an attempt.
    pub fn with_timeout(
        base_url: &str,
        access_token: &str,
        timeout: Duration,
    ) -> Result<Self, Error> {
        let mut config = ClientConfig::new(base_url, access_token);
        config.timeout = timeout;
        Self::with_config(config)
    }

    /// A client from a configuration. It refuses a base URL that isn't an origin, a
    /// token or User-Agent that can't be a header, a timeout no deadline can be set
    /// by and more than 10 retries.
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
        // Amazon's sandbox is the host of a selling region after `sandbox.`.
        let sandbox = origin
            .host_str()
            .is_some_and(|host| host.starts_with("sandbox."));
        Ok(Self {
            pool,
            origin,
            token,
            user_agent,
            retry,
            timeout,
            sandbox,
            rate_limit: None,
        })
    }

    /// A view with another access token that shares the pool and the policy: another
    /// seller, a rotated token, or a restricted data token for a few calls.
    pub fn with_access_token(&self, access_token: &str) -> Result<Self, Error> {
        let mut view = self.clone();
        view.token = Token::Static(token_header(access_token)?);
        Ok(view)
    }

    /// A view whose calls wait after a 429 by `rate` requests per second, in place of
    /// the rate Amazon documents for each operation: for a seller whose limit differs.
    /// `None` is no rate, so a 429 waits as a 503 does. Nothing is paced, and a call
    /// that isn't throttled is unchanged. It refuses a rate that isn't a positive,
    /// finite number.
    pub fn with_rate_limit(&self, rate: Option<f64>) -> Result<Self, Error> {
        if rate.is_some_and(|rate| !(rate.is_finite() && rate > 0.0)) {
            return Err(Error::InvalidRequest);
        }
        let mut view = self.clone();
        view.rate_limit = Some(rate);
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

    /// Runs `send` once per attempt, with that attempt's token. The timeout limits
    /// each attempt, asking a token source included. The waits between attempts, which
    /// the policy sets, are not counted against it. `rate` is the requests per second
    /// Amazon documents for the operation, if this is one and it has one. The rate a
    /// view was given replaces it.
    async fn run<F, Fut>(&self, method: &str, rate: Option<f64>, send: F) -> Result<Response, Error>
    where
        F: Fn(HeaderValue) -> Fut,
        Fut: Future<Output = Result<Response, Error>>,
    {
        let call = Call {
            method,
            rate: self.rate_limit.unwrap_or(rate),
            sandbox: self.sandbox,
        };
        let mut retry = 0;
        loop {
            let attempt = async { send(self.token().await?).await };
            let result = tokio::time::timeout(self.timeout, attempt)
                .await
                .unwrap_or(Err(Error::Timeout));
            let outcome = match &result {
                Ok(response) => Outcome::Response {
                    status: response.status,
                    headers: &response.headers,
                },
                Err(Error::Timeout | Error::Transport) => Outcome::Failed,
                // What another attempt wouldn't change. A token source that failed is not
                // asked again.
                Err(_) => return result,
            };
            retry += 1;
            let Some(wait) = self.retry.wait(call, outcome, retry) else {
                return result;
            };
            tokio::time::sleep(wait).await;
        }
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

    /// Sends a request with the client's access token, timeout and retries, and
    /// returns the response whatever its status. It has no documented rate, so a
    /// retry after a 429 waits as one after a 503 does, unless the client is a view
    /// with a rate: see [`Client::with_rate_limit`].
    pub async fn execute(&self, request: Request) -> Result<Response, Error> {
        self.execute_inner(request, false, None).await
    }

    /// Like `execute`, as a generated operation sends it: with its `Accept` header and
    /// the requests per second Amazon documents for it, if any, which set the wait
    /// after a 429.
    pub(crate) async fn execute_json(
        &self,
        request: Request,
        rate: Option<f64>,
    ) -> Result<Response, Error> {
        self.execute_inner(request, true, rate).await
    }

    async fn execute_inner(
        &self,
        request: Request,
        accept_json: bool,
        rate: Option<f64>,
    ) -> Result<Response, Error> {
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
        let mut builder = self.pool.http.request(method, url).timeout(self.timeout);
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
        self.run(&method_name, rate, |token| {
            let mut request = buffered.try_clone().expect("buffered body is repeatable");
            async move {
                self.authorize(request.headers_mut(), &token);
                if let Some(interceptor) = self.pool.interceptor() {
                    return Ok(self.pool.intercepted(interceptor, request).await?);
                }
                let response = self
                    .pool
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

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::atomic::{AtomicUsize, Ordering};
    use tokio::time::Instant;

    /// How one attempt ends.
    #[derive(Clone, Copy)]
    enum Attempt {
        Status(u16),
        /// A 429 whose `Retry-After` asks for this many seconds.
        Asks(u64),
        /// The connection fails.
        Fails,
        /// Nothing answers.
        Hangs,
        /// The token source fails.
        Unauthenticated,
    }
    use Attempt::*;

    fn client(retries: u32) -> Client {
        let mut config = ClientConfig::new("https://sellingpartnerapi-eu.amazon.com", "token");
        config.retry.max_retries = retries;
        Client::with_config(config).unwrap()
    }

    /// Runs a call whose attempts end as scripted. Returns the status or the error, the
    /// number of attempts and the time the call took on the paused clock, in seconds.
    async fn run(
        client: &Client,
        method: &str,
        rate: Option<f64>,
        script: &[Attempt],
    ) -> (Result<u16, Error>, usize, f64) {
        let attempts = AtomicUsize::new(0);
        let started = Instant::now();
        let result = client
            .run(method, rate, |_token| {
                let attempt = script[attempts.fetch_add(1, Ordering::SeqCst)];
                async move {
                    match attempt {
                        Status(status) => Ok(Response {
                            status,
                            headers: Vec::new(),
                            body: Vec::new(),
                        }),
                        Asks(seconds) => Ok(Response {
                            status: 429,
                            headers: vec![("retry-after".into(), seconds.to_string())],
                            body: Vec::new(),
                        }),
                        Fails => Err(Error::Transport),
                        Hangs => std::future::pending().await,
                        Unauthenticated => Err(Error::Authentication(AuthError::InvalidResponse)),
                    }
                }
            })
            .await;
        (
            result.map(|response| response.status),
            attempts.into_inner(),
            started.elapsed().as_secs_f64(),
        )
    }

    /// Whether a call took from `least` to `most` seconds. The paused clock ends each
    /// wait on a whole millisecond, so a call may take a few more than its waits add
    /// up to.
    fn took(elapsed: f64, least: f64, most: f64) -> bool {
        (least..=most + 0.01).contains(&elapsed)
    }

    #[tokio::test(start_paused = true)]
    async fn a_wait_between_attempts_is_not_counted_against_the_timeout() {
        // The first wait alone, a minute, is twice the timeout of 30 seconds.
        let script = [Status(429), Status(429), Status(200)];
        let (result, attempts, elapsed) = run(&client(2), "GET", Some(0.0167), &script).await;
        assert_eq!((result, attempts), (Ok(200), 3));
        let waits = 3.0 / 0.0167;
        assert!(took(elapsed, waits, waits + 0.2), "{elapsed}");
    }

    #[tokio::test(start_paused = true)]
    async fn the_timeout_limits_each_attempt_and_a_safe_method_tries_again() {
        let (result, attempts, elapsed) =
            run(&client(2), "GET", None, &[Hangs, Hangs, Status(200)]).await;
        assert_eq!((result, attempts), (Ok(200), 3));
        // 2 attempts of 30 seconds, a wait of up to 1 second and one of 1 to 2.
        assert!(took(elapsed, 61.0, 63.0), "{elapsed}");
        let (result, attempts, elapsed) = run(&client(2), "GET", None, &[Hangs; 3]).await;
        assert_eq!((result, attempts), (Err(Error::Timeout), 3));
        assert!(took(elapsed, 91.0, 93.0), "{elapsed}");
        // A write that got no answer may have been processed.
        for method in ["POST", "PUT", "PATCH", "DELETE"] {
            let (result, attempts, elapsed) = run(&client(2), method, Some(5.0), &[Hangs]).await;
            assert_eq!((result, attempts), (Err(Error::Timeout), 1), "{method}");
            assert!(took(elapsed, 30.0, 30.1), "{elapsed}");
        }
    }

    #[tokio::test(start_paused = true)]
    async fn a_failed_connection_is_retried_for_a_safe_method_only() {
        for method in ["GET", "HEAD", "OPTIONS"] {
            let (result, attempts, elapsed) = run(&client(3), method, Some(5.0), &[Fails; 4]).await;
            assert_eq!((result, attempts), (Err(Error::Transport), 4), "{method}");
            // Up to 1 second, then 1 to 2, then 3 to 4.
            assert!(took(elapsed, 4.0, 7.0), "{elapsed}");
        }
        let (result, attempts, _) = run(&client(3), "GET", None, &[Fails, Status(200)]).await;
        assert_eq!((result, attempts), (Ok(200), 2));
        for method in ["POST", "PUT", "PATCH", "DELETE"] {
            let (result, attempts, elapsed) = run(&client(3), method, Some(5.0), &[Fails]).await;
            assert_eq!((result, attempts), (Err(Error::Transport), 1), "{method}");
            assert_eq!(elapsed, 0.0);
        }
    }

    #[tokio::test(start_paused = true)]
    async fn a_write_is_retried_after_a_429_and_not_after_a_5xx() {
        for method in ["POST", "PUT", "PATCH", "DELETE"] {
            let script = [Status(429), Status(429), Status(201)];
            let (result, attempts, elapsed) = run(&client(2), method, Some(5.0), &script).await;
            assert_eq!((result, attempts), (Ok(201), 3), "{method}");
            // A fifth of a second, then 2 fifths, and up to a tenth more each.
            assert!(took(elapsed, 0.6, 0.8), "{elapsed}");
            for status in [500, 502, 503, 504] {
                let (result, attempts, elapsed) =
                    run(&client(2), method, Some(5.0), &[Status(status)]).await;
                assert_eq!((result, attempts), (Ok(status), 1), "{method}");
                assert_eq!(elapsed, 0.0);
            }
        }
        // The last response is returned when the retries run out.
        let (result, attempts, _) = run(&client(2), "POST", Some(80.0), &[Status(429); 3]).await;
        assert_eq!((result, attempts), (Ok(429), 3));
    }

    #[tokio::test(start_paused = true)]
    async fn a_call_without_a_rate_waits_after_a_429_as_after_a_503() {
        for status in [429, 500, 502, 503, 504] {
            let script = [Status(status), Status(status), Status(status), Status(200)];
            let (result, attempts, elapsed) = run(&client(3), "GET", None, &script).await;
            assert_eq!((result, attempts), (Ok(200), 4), "{status}");
            assert!(took(elapsed, 4.0, 7.0), "{status} {elapsed}");
        }
    }

    #[tokio::test(start_paused = true)]
    async fn nothing_is_retried_by_default_or_when_another_attempt_changes_nothing() {
        for attempt in [Status(429), Status(503), Fails] {
            let (_, attempts, elapsed) = run(&client(0), "GET", Some(5.0), &[attempt]).await;
            assert_eq!((attempts, elapsed), (1, 0.0));
        }
        for attempt in [
            Status(200),
            Status(400),
            Status(404),
            Status(501),
            Unauthenticated,
        ] {
            let (_, attempts, elapsed) = run(&client(10), "GET", Some(5.0), &[attempt]).await;
            assert_eq!((attempts, elapsed), (1, 0.0));
        }
    }

    #[tokio::test(start_paused = true)]
    async fn a_wait_is_as_long_as_the_rate_or_retry_after_asks() {
        // What `Retry-After` asks for: a day.
        let script = [Asks(86_400), Status(200)];
        let (result, attempts, elapsed) = run(&client(1), "GET", Some(80.0), &script).await;
        assert_eq!((result, attempts), (Ok(200), 2));
        assert!(took(elapsed, 86_400.0, 86_400.0), "{elapsed}");
        // What the rate asks for. At 1 request a minute the 10 retries wait a minute,
        // then 2, and so on to 512: 1023 minutes, and up to a tenth of a second each.
        let (result, attempts, elapsed) =
            run(&client(10), "POST", Some(0.0167), &[Status(429); 11]).await;
        assert_eq!((result, attempts), (Ok(429), 11));
        assert!(
            took(elapsed, 1023.0 / 0.0167, 1023.0 / 0.0167 + 1.0),
            "{elapsed}"
        );
    }

    #[tokio::test(start_paused = true)]
    async fn a_retry_after_longer_than_any_clock_is_waited_for_and_ends_when_the_call_is_dropped() {
        let client = client(1);
        let attempts = AtomicUsize::new(0);
        let call = client.run("GET", Some(80.0), |_token| {
            attempts.fetch_add(1, Ordering::SeqCst);
            std::future::ready(Ok(Response {
                status: 429,
                headers: vec![("retry-after".into(), u64::MAX.to_string())],
                body: Vec::new(),
            }))
        });
        // Nothing but the caller ends such a wait. A day later it still goes on.
        let day = Duration::from_secs(86_400);
        assert!(tokio::time::timeout(day, call).await.is_err());
        assert_eq!(attempts.into_inner(), 1);
    }

    #[tokio::test(start_paused = true)]
    async fn the_sandbox_is_known_by_its_host_and_waits_a_fifth_of_a_second() {
        let mut config = ClientConfig::new("https://sandbox.sellingpartnerapi-na.amazon.com", "t");
        config.retry.max_retries = 1;
        let sandbox = Client::with_config(config).unwrap();
        let script = [Status(429), Status(200)];
        let (result, _, elapsed) = run(&sandbox, "GET", Some(0.0167), &script).await;
        assert_eq!(result, Ok(200));
        assert!(took(elapsed, 0.2, 0.3), "{elapsed}");
        // A view with another token calls the same host.
        let view = sandbox.with_access_token("other").unwrap();
        let (_, _, elapsed) = run(&view, "GET", Some(0.0167), &script).await;
        assert!(took(elapsed, 0.2, 0.3), "{elapsed}");
        for production in [
            "https://sellingpartnerapi-na.amazon.com",
            "http://localhost:1",
        ] {
            assert!(
                !Client::new(production, "t").unwrap().sandbox,
                "{production}"
            );
        }
    }

    #[tokio::test(start_paused = true)]
    async fn a_view_with_a_rate_waits_by_it_in_place_of_the_documented_one() {
        let script = [Status(429), Status(429), Status(200)];
        // At 100 requests a second: a hundredth of a second, then 2, and up to a tenth
        // more each. By the documented rate the first wait alone would be a minute.
        let slow = client(2);
        let fast = slow.with_rate_limit(Some(100.0)).unwrap();
        let (result, attempts, elapsed) = run(&fast, "GET", Some(0.0167), &script).await;
        assert_eq!((result, attempts), (Ok(200), 3));
        assert!(took(elapsed, 0.03, 0.23), "{elapsed}");
        // A call without a documented rate waits by it too.
        let (_, _, elapsed) = run(&fast, "POST", None, &script).await;
        assert!(took(elapsed, 0.03, 0.23), "{elapsed}");
        // A view of the view keeps the rate. The client it came from never had it.
        let view = fast.with_access_token("other").unwrap();
        let (_, _, elapsed) = run(&view, "GET", Some(0.0167), &script).await;
        assert!(took(elapsed, 0.03, 0.23), "{elapsed}");
        let (_, _, elapsed) = run(&slow, "GET", Some(0.0167), &script).await;
        assert!(took(elapsed, 3.0 / 0.0167, 3.0 / 0.0167 + 0.2), "{elapsed}");
        // No rate: up to 1 second, then 1 to 2, as after a 503.
        let unrated = slow.with_rate_limit(None).unwrap();
        let (result, attempts, elapsed) = run(&unrated, "GET", Some(80.0), &script).await;
        assert_eq!((result, attempts), (Ok(200), 3));
        assert!(took(elapsed, 1.0, 3.0), "{elapsed}");
        // Nothing is paced: a call that isn't throttled doesn't wait.
        let (_, attempts, elapsed) = run(&fast, "GET", Some(0.0167), &[Status(200)]).await;
        assert_eq!((attempts, elapsed), (1, 0.0));
        for rate in [0.0, -1.0, f64::NAN, f64::INFINITY, f64::NEG_INFINITY] {
            let refused = slow.with_rate_limit(Some(rate)).unwrap_err();
            assert_eq!(refused, Error::InvalidRequest, "{rate}");
        }
    }
}
