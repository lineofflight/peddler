//! Shared asynchronous SP-API transport. HTTP error statuses remain responses.

#[rustfmt::skip]
pub mod apis;

pub mod api_error;
pub mod auth;
pub mod documents;
pub mod policy;

mod operation;
pub use operation::TypedResponse;

use auth::{AuthError, AuthManager, Credentials, RestrictedScope};
use policy::{PolicyConfig, RequestPolicy};
use reqwest::{Method, Url, header::HeaderValue};
use std::{future::Future, time::Duration};

pub const DEFAULT_LWA_ENDPOINT: &str = "https://api.amazon.com/auth/o2/token";

/// Authentication and policy configuration. Construction performs no HTTP.
pub struct ClientConfig {
    pub base_url: String,
    pub credentials: Credentials,
    pub timeout: Duration,
    pub lwa_endpoint: String,
    pub policy: PolicyConfig,
}
impl ClientConfig {
    pub fn new(base_url: impl Into<String>, credentials: Credentials) -> Self {
        Self {
            base_url: base_url.into(),
            credentials,
            timeout: Duration::from_secs(30),
            lwa_endpoint: DEFAULT_LWA_ENDPOINT.into(),
            policy: PolicyConfig::default(),
        }
    }
}

/// Clones share the same HTTP connection pool.
#[derive(Clone)]
pub struct Client {
    http: reqwest::Client,
    origin: Url,
    access_token: Option<HeaderValue>,
    auth: AuthManager,
    policy: RequestPolicy,
    restricted_scope: Option<RestrictedScope>,
    timeout: Duration,
}

impl std::fmt::Debug for Client {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Client").finish_non_exhaustive()
    }
}

#[derive(Debug)]
pub struct Request {
    pub method: String,
    pub path: String,
    pub query: Vec<(String, String)>,
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
        Self::with_timeout(base_url, access_token, Duration::from_secs(30))
    }

    pub fn with_timeout(
        base_url: &str,
        access_token: &str,
        timeout: Duration,
    ) -> Result<Self, Error> {
        let mut config = ClientConfig::new(base_url, Credentials::AccessToken(access_token.into()));
        config.timeout = timeout;
        Self::with_config(config)
    }

    pub fn with_config(config: ClientConfig) -> Result<Self, Error> {
        let ClientConfig {
            base_url,
            credentials,
            timeout,
            lwa_endpoint,
            policy,
        } = config;
        // Check the original text too: URL parsing normalizes backslashes,
        // userinfo and dot segments that callers must not supply as an origin.
        let (scheme, remainder) = base_url.split_once("://").ok_or(Error::InvalidRequest)?;
        let (authority, path) = remainder.split_once('/').unwrap_or((remainder, ""));
        if !matches!(scheme, "http" | "https")
            || authority.is_empty()
            || authority.contains('@')
            || !path.is_empty()
            || base_url
                .chars()
                .any(|c| c.is_whitespace() || c.is_control() || matches!(c, '\\' | '?' | '#'))
            || timeout.is_zero()
        {
            return Err(Error::InvalidRequest);
        }
        let origin = Url::parse(&base_url).map_err(|_| Error::InvalidRequest)?;
        if origin.host_str().is_none() || origin.path() != "/" {
            return Err(Error::InvalidRequest);
        }
        let http = reqwest::Client::builder()
            .timeout(timeout)
            .redirect(reqwest::redirect::Policy::none())
            .retry(reqwest::retry::never())
            .no_gzip()
            .no_brotli()
            .no_deflate()
            .no_zstd()
            .user_agent(concat!(
                "Peddler/",
                env!("CARGO_PKG_VERSION"),
                " (Language=Rust)"
            ))
            .build()
            .map_err(|_| Error::Transport)?;
        let auth = AuthManager::new(http.clone(), &base_url, credentials, &lwa_endpoint)
            .map_err(classify_auth)?;
        let policy = RequestPolicy::new(policy).map_err(|_| Error::InvalidRequest)?;
        Ok(Self {
            http,
            origin,
            access_token: None,
            auth,
            policy,
            restricted_scope: None,
            timeout,
        })
    }

    pub fn restricted(&self, scope: RestrictedScope) -> Result<Self, Error> {
        scope.validate().map_err(classify_auth)?;
        let mut view = self.clone();
        view.restricted_scope = Some(scope);
        view.access_token = None;
        Ok(view)
    }

    pub(crate) async fn run<F, Fut>(
        &self,
        operation: &str,
        method: &str,
        send: F,
    ) -> Result<Response, Error>
    where
        F: Fn(Client) -> Fut,
        Fut: Future<Output = Result<Response, Error>>,
    {
        if operation.is_empty() {
            return Err(Error::InvalidRequest);
        }
        let deadline = tokio::time::Instant::now()
            .checked_add(self.timeout)
            .ok_or(Error::InvalidRequest)?;
        tokio::time::timeout_at(deadline, async {
            let mut retry_index = 0;
            loop {
                self.policy.acquire(operation).await;
                let token = self
                    .auth
                    .token(self.restricted_scope.as_ref())
                    .await
                    .map_err(classify_auth)?;
                let mut snapshot = self.clone();
                snapshot.access_token = Some(token);
                let response = send(snapshot).await?;
                self.policy.observe(operation, &response.headers);
                let Some(delay) = self.policy.retry_delay(
                    method,
                    response.status,
                    &response.headers,
                    retry_index,
                ) else {
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

    pub(crate) fn prepare_generated(
        &self,
        request: &mut reqwest::Request,
        csv_names: &[&str],
    ) -> Result<(), Error> {
        let url = request.url();
        if url.origin() != self.origin.origin()
            || !url.username().is_empty()
            || url.password().is_some()
            || url.fragment().is_some()
        {
            return Err(Error::InvalidRequest);
        }
        // Discard per-request overrides so the shared client's timeout applies.
        *request.timeout_mut() = None;
        // Canonicalize individual segments, never decode the whole path. A raw
        // caller %2F was already escaped by Progenitor to %252F and stays literal.
        const SEGMENT: &percent_encoding::AsciiSet = &percent_encoding::NON_ALPHANUMERIC
            .remove(b'-')
            .remove(b'_')
            .remove(b'.')
            .remove(b'~');
        let path = request
            .url()
            .path()
            .split('/')
            .map(|segment| {
                let bytes = percent_encoding::percent_decode_str(segment).collect::<Vec<_>>();
                percent_encoding::percent_encode(&bytes, SEGMENT).to_string()
            })
            .collect::<Vec<_>>()
            .join("/");
        request.url_mut().set_path(&path);
        if request.url().query().is_some() {
            let mut pairs: Vec<(String, String)> = Vec::new();
            for (key, value) in request.url().query_pairs() {
                if csv_names.contains(&key.as_ref())
                    && let Some((_, previous)) = pairs.iter_mut().find(|(name, _)| name == &key)
                {
                    previous.push(',');
                    previous.push_str(&value);
                    continue;
                }
                pairs.push((key.into_owned(), value.into_owned()));
            }
            request.url_mut().set_query(None);
            if !pairs.is_empty() {
                request.url_mut().query_pairs_mut().extend_pairs(pairs);
            }
        }
        request.headers_mut().insert(
            "x-amz-access-token",
            self.access_token.clone().ok_or(Error::InvalidRequest)?,
        );
        request.headers_mut().insert(
            reqwest::header::ACCEPT,
            HeaderValue::from_static("application/json"),
        );
        Ok(())
    }

    pub async fn execute(&self, request: Request) -> Result<Response, Error> {
        self.execute_with_operation("raw", request).await
    }

    pub async fn execute_with_operation(
        &self,
        operation: &str,
        request: Request,
    ) -> Result<Response, Error> {
        if operation.is_empty() {
            return Err(Error::InvalidRequest);
        }
        if !request.path.starts_with('/')
            || request.path.starts_with("//")
            || request
                .path
                .chars()
                .any(|c| c.is_whitespace() || c.is_control() || matches!(c, '\\' | '?' | '#'))
        {
            return Err(Error::InvalidRequest);
        }
        let path = request.path.as_bytes();
        for (index, byte) in path.iter().enumerate() {
            if *byte == b'%'
                && !path
                    .get(index + 1..index + 3)
                    .is_some_and(|bytes| bytes.iter().all(u8::is_ascii_hexdigit))
            {
                return Err(Error::InvalidRequest);
            }
        }
        let method =
            Method::from_bytes(request.method.as_bytes()).map_err(|_| Error::InvalidRequest)?;
        let mut url = self.origin.clone();
        url.set_path(&request.path);
        if !request.query.is_empty() {
            url.query_pairs_mut().extend_pairs(&request.query);
        }
        let method_name = method.as_str().to_owned();
        let mut builder = self.http.request(method, url);
        if let Some(body) = request.body {
            builder = builder
                .header(reqwest::header::CONTENT_TYPE, "application/json")
                .body(body);
        }
        let buffered = builder.build().map_err(|_| Error::InvalidRequest)?;
        self.run(operation, &method_name, |snapshot| {
            let mut request = buffered.try_clone().expect("buffered body is repeatable");
            async move {
                request.headers_mut().insert(
                    "x-amz-access-token",
                    snapshot.access_token.ok_or(Error::InvalidRequest)?,
                );
                let response = snapshot
                    .http
                    .execute(request)
                    .await
                    .map_err(classify_transport)?;
                operation::collect(Ok(progenitor_client::ResponseValue::stream(response))).await
            }
        })
        .await
    }
}

// Never retain reqwest errors: their Display/Debug/source may contain URLs.
fn classify_transport(error: reqwest::Error) -> Error {
    if error.is_timeout() {
        Error::Timeout
    } else {
        Error::Transport
    }
}

fn classify_auth(error: AuthError) -> Error {
    match error {
        AuthError::Timeout => Error::Timeout,
        AuthError::Transport => Error::Transport,
        AuthError::InvalidConfig => Error::InvalidRequest,
        error => Error::Authentication(error),
    }
}
