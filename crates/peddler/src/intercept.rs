//! Lets a wrapper answer the crate's HTTP exchanges itself, as a test double does. The
//! Ruby gem's WebMock adapter is built on it.
//!
//! A [`Pool`] with an [`Interceptor`] asks it before every exchange of the clients
//! built on the pool: an API request, a Login with Amazon grant, a download from a
//! signed URL and an upload to one. While the interceptor says it is enabled, the
//! exchange is handed to it whole and it answers, fails, or lets the request go out and
//! sees the response. Everything around the exchange stays as it is: the token of the
//! attempt, timeouts, retries, decoding and errors.
//!
//! An intercepted exchange is buffered: an upload is read to its end before it is
//! handed over, as a copy, and a download arrives whole before its first byte is read.
//!
//! It is hidden from the documentation because the crate doesn't promise to keep it.

use crate::{Pool, Response};
use reqwest::header::{ACCEPT, HeaderMap, HeaderName, HeaderValue, USER_AGENT};
use std::{fmt, future::Future, pin::Pin, sync::Arc};

/// A request as the crate sends it. It holds an access token, a signed URL or the
/// credentials of a grant, so `Debug` shows the method only.
pub struct Exchange {
    /// The HTTP method, in uppercase.
    pub method: String,
    /// The whole URL, with its query.
    pub url: String,
    /// The headers the crate and its HTTP client set, their names in lowercase. The
    /// transport writes `host`, and `content-length` unless the request names one.
    pub headers: Vec<(String, String)>,
    /// The body, empty when the request has none.
    pub body: Vec<u8>,
}

impl fmt::Debug for Exchange {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Exchange")
            .field("method", &self.method)
            .finish_non_exhaustive()
    }
}

/// An exchange without a response. Each client reports it as its own error does.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Failure {
    /// The exchange took too long.
    Timeout,
    /// The request couldn't be sent or the response couldn't be read.
    Transport,
}

/// The response of an exchange, once it is there.
pub type Reply<'a> = Pin<Box<dyn Future<Output = Result<Response, Failure>> + Send + 'a>>;

/// What stands between the crate and the network.
pub trait Interceptor: Send + Sync + 'static {
    /// Whether the exchange the calling task is about to make goes to `exchange`. It is
    /// asked before every exchange, and nothing else changes while it says no.
    fn enabled(&self) -> bool;

    /// Answers the exchange. `real` sends the request and reads the whole response when
    /// it is awaited, and sends nothing when it is dropped.
    fn exchange<'a>(&'a self, exchange: Exchange, real: Reply<'a>) -> Reply<'a>;
}

impl Pool {
    /// The same pool, whose clients ask `interceptor` before every exchange. Hidden with
    /// the module: an inherent method of a public type isn't covered by it.
    #[doc(hidden)]
    pub fn with_interceptor(mut self, interceptor: impl Interceptor) -> Self {
        self.interceptor = Some(Arc::new(interceptor));
        self
    }

    /// The interceptor, when the pool has one and it takes the next exchange.
    pub(crate) fn interceptor(&self) -> Option<&dyn Interceptor> {
        self.interceptor
            .as_deref()
            .filter(|interceptor| interceptor.enabled())
    }

    /// Hands a request with a buffered body to the interceptor.
    pub(crate) async fn intercepted(
        &self,
        interceptor: &dyn Interceptor,
        request: reqwest::Request,
    ) -> Result<Response, Failure> {
        let exchange = Exchange {
            method: request.method().as_str().to_owned(),
            url: request.url().as_str().to_owned(),
            headers: self.sent(request.headers()),
            // A copy: the request keeps its body for `real`, and lends it only.
            body: request
                .body()
                .and_then(reqwest::Body::as_bytes)
                .unwrap_or_default()
                .to_vec(),
        };
        let real = Box::pin(async move {
            let response = self.http.execute(request).await.map_err(failure)?;
            let status = response.status().as_u16();
            let headers = pairs(response.headers());
            let body = response.bytes().await.map_err(failure)?.into();
            Ok(Response {
                status,
                headers,
                body,
            })
        });
        interceptor.exchange(exchange, real).await
    }

    /// The headers of a request with those the HTTP client adds when it sends one that
    /// lacks them.
    fn sent(&self, headers: &HeaderMap) -> Vec<(String, String)> {
        let mut sent = pairs(headers);
        if !headers.contains_key(USER_AGENT) {
            sent.push((USER_AGENT.as_str().to_owned(), text(&self.user_agent)));
        }
        if !headers.contains_key(ACCEPT) {
            sent.push((ACCEPT.as_str().to_owned(), "*/*".to_owned()));
        }
        sent
    }
}

fn text(value: &HeaderValue) -> String {
    String::from_utf8_lossy(value.as_bytes()).into_owned()
}

fn pairs(headers: &HeaderMap) -> Vec<(String, String)> {
    headers
        .iter()
        .map(|(name, value)| (name.as_str().to_owned(), text(value)))
        .collect()
}

/// The headers of a buffered response as a transfer keeps them. One that can't be a
/// header, which only an interceptor can answer with, is left out.
pub(crate) fn header_map(headers: &[(String, String)]) -> HeaderMap {
    let mut map = HeaderMap::new();
    for (name, value) in headers {
        if let (Ok(name), Ok(value)) = (
            HeaderName::from_bytes(name.as_bytes()),
            HeaderValue::from_bytes(value.as_bytes()),
        ) {
            map.append(name, value);
        }
    }
    map
}

fn failure(error: reqwest::Error) -> Failure {
    crate::classify(error, Failure::Timeout, Failure::Transport)
}

impl From<Failure> for crate::Error {
    fn from(failure: Failure) -> Self {
        match failure {
            Failure::Timeout => Self::Timeout,
            Failure::Transport => Self::Transport,
        }
    }
}

impl From<Failure> for crate::auth::AuthError {
    fn from(failure: Failure) -> Self {
        match failure {
            Failure::Timeout => Self::Timeout,
            Failure::Transport => Self::Transport,
        }
    }
}

impl From<Failure> for crate::documents::Error {
    fn from(failure: Failure) -> Self {
        match failure {
            Failure::Timeout => Self::Timeout,
            Failure::Transport => Self::Transport,
        }
    }
}
