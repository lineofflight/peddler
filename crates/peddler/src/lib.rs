//! Shared asynchronous SP-API transport. HTTP error statuses remain responses.

#[rustfmt::skip]
pub mod apis;

use reqwest::{Method, Url, header::HeaderValue};
use std::time::Duration;

/// Clones share the same HTTP connection pool.
#[derive(Clone)]
pub struct Client {
    http: reqwest::Client,
    origin: Url,
    access_token: HeaderValue,
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
}

impl std::fmt::Display for Error {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(match self {
            Self::InvalidRequest => "invalid request",
            Self::Timeout => "request timed out",
            Self::Transport => "transport failed",
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
            || access_token.is_empty()
        {
            return Err(Error::InvalidRequest);
        }
        let origin = Url::parse(base_url).map_err(|_| Error::InvalidRequest)?;
        if origin.host_str().is_none() || origin.path() != "/" {
            return Err(Error::InvalidRequest);
        }
        let mut access_token =
            HeaderValue::from_str(access_token).map_err(|_| Error::InvalidRequest)?;
        access_token.set_sensitive(true);
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
        Ok(Self {
            http,
            origin,
            access_token,
        })
    }

    pub async fn execute(&self, request: Request) -> Result<Response, Error> {
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
        let mut builder = self
            .http
            .request(method, url)
            .header("x-amz-access-token", self.access_token.clone());
        if let Some(body) = request.body {
            builder = builder
                .header(reqwest::header::CONTENT_TYPE, "application/json")
                .body(body);
        }
        let response = builder.send().await.map_err(classify_transport)?;
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
        let body = response.bytes().await.map_err(classify_transport)?.to_vec();
        Ok(Response {
            status,
            headers,
            body,
        })
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
