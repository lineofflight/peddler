//! Login with Amazon and restricted data token authentication.
//!
//! The caller configures HTTP redirects, retries and deadlines on the supplied
//! client. Clones share in-memory tokens; no credentials or tokens are persisted.

use futures_util::{
    FutureExt, StreamExt,
    future::{BoxFuture, Shared},
};
use reqwest::{Url, header::HeaderValue};
use serde::{Deserialize, Serialize};
use std::{
    collections::HashMap,
    fmt,
    sync::{Arc, Mutex},
    time::Duration,
};
use tokio::{sync::Notify, time::Instant};

const BODY_LIMIT: usize = 64 * 1024;
const SCOPE_LIMIT: usize = 128;

#[derive(Clone)]
pub enum Credentials {
    AccessToken(String),
    RefreshToken {
        client_id: String,
        client_secret: String,
        refresh_token: String,
    },
    ClientCredentials {
        client_id: String,
        client_secret: String,
        scope: String,
    },
}

impl fmt::Debug for Credentials {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(match self {
            Self::AccessToken(_) => "AccessToken([redacted])",
            Self::RefreshToken { .. } => "RefreshToken([redacted])",
            Self::ClientCredentials { .. } => "ClientCredentials([redacted])",
        })
    }
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq, PartialOrd, Ord, Hash)]
#[serde(deny_unknown_fields)]
pub struct RestrictedResource {
    pub method: String,
    pub path: String,
    #[serde(default)]
    pub data_elements: Vec<String>,
}

#[derive(Clone, Debug, Deserialize, Serialize, PartialEq, Eq, Hash)]
#[serde(deny_unknown_fields)]
pub struct RestrictedScope {
    pub resources: Vec<RestrictedResource>,
    #[serde(default)]
    pub target_application: Option<String>,
}

impl RestrictedScope {
    /// Validate the scope before starting any authentication request.
    pub fn validate(&self) -> Result<(), AuthError> {
        canonical_scope(self).map(|_| ())
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum AuthError {
    InvalidConfig,
    InvalidResponse,
    Rejected(u16),
    Timeout,
    Transport,
}

impl fmt::Display for AuthError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidConfig => f.write_str("invalid authentication configuration"),
            Self::InvalidResponse => f.write_str("invalid authentication response"),
            Self::Rejected(status) => write!(f, "authentication rejected ({status})"),
            Self::Timeout => f.write_str("authentication timed out"),
            Self::Transport => f.write_str("authentication transport failed"),
        }
    }
}
impl std::error::Error for AuthError {}

struct Config {
    http: reqwest::Client,
    origin: Url,
    credentials: Credentials,
    lwa_endpoint: Url,
    static_token: Option<HeaderValue>,
}

#[derive(Clone)]
struct Token {
    value: HeaderValue,
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
// flight while any waiter remains, including the base waiter held by RDT work.
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
        // Dropping a flight can release sockets or nested base-token leases.
        // Their cleanup must run without holding this slot's mutex.
        drop(abandoned);
    }
}
struct ScopeEntry {
    slot: Arc<Mutex<Slot>>,
    touched: u64,
}
#[derive(Default)]
struct ScopeCache {
    entries: HashMap<RestrictedScope, ScopeEntry>,
    clock: u64,
}

// Keep active scopes addressable until their last waiter finishes or cancels.
// Release the slot before waking capacity waiters so eviction sees it as idle.
struct ScopeLease {
    slot: Option<Arc<Mutex<Slot>>>,
    capacity: Arc<Notify>,
}
impl Drop for ScopeLease {
    fn drop(&mut self) {
        self.slot.take();
        self.capacity.notify_waiters();
    }
}

/// Clones share caches and the supplied HTTP connection pool.
#[derive(Clone)]
pub struct AuthManager {
    config: Arc<Config>,
    base: Arc<Mutex<Slot>>,
    restricted: Arc<Mutex<ScopeCache>>,
    capacity: Arc<Notify>,
}
impl fmt::Debug for AuthManager {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("AuthManager").finish_non_exhaustive()
    }
}

impl AuthManager {
    pub fn new(
        http: reqwest::Client,
        sp_api_origin: &str,
        credentials: Credentials,
        lwa_endpoint: &str,
    ) -> Result<Self, AuthError> {
        let origin = endpoint(sp_api_origin, true)?;
        let lwa_endpoint = endpoint(lwa_endpoint, false)?;
        let static_token = match &credentials {
            Credentials::AccessToken(token) => {
                Some(header_token(token).map_err(|_| AuthError::InvalidConfig)?)
            }
            Credentials::RefreshToken {
                client_id,
                client_secret,
                refresh_token,
            } => {
                if [client_id, client_secret, refresh_token]
                    .into_iter()
                    .any(|value| value.trim().is_empty())
                {
                    return Err(AuthError::InvalidConfig);
                }
                None
            }
            Credentials::ClientCredentials {
                client_id,
                client_secret,
                scope,
            } => {
                if [client_id, client_secret, scope]
                    .into_iter()
                    .any(|value| value.trim().is_empty())
                {
                    return Err(AuthError::InvalidConfig);
                }
                None
            }
        };
        Ok(Self {
            config: Arc::new(Config {
                http,
                origin,
                credentials,
                lwa_endpoint,
                static_token,
            }),
            base: Arc::new(Mutex::new(Slot::default())),
            restricted: Arc::new(Mutex::new(ScopeCache::default())),
            capacity: Arc::new(Notify::new()),
        })
    }

    pub async fn token(&self, scope: Option<&RestrictedScope>) -> Result<HeaderValue, AuthError> {
        let Some(scope) = scope else {
            return base_token(self.config.clone(), self.base.clone()).await;
        };
        let scope = canonical_scope(scope)?;
        let lease = self.scope_slot(&scope).await?;
        let config = self.config.clone();
        let base = self.base.clone();
        cached(lease.slot.as_ref().unwrap().clone(), move || {
            async move {
                let token = base_token(config.clone(), base).await?;
                let resources: Vec<_> = scope
                    .resources
                    .iter()
                    .map(|resource| WireResource {
                        method: &resource.method,
                        path: &resource.path,
                        data_elements: &resource.data_elements,
                    })
                    .collect();
                let body = WireScope {
                    restricted_resources: &resources,
                    target_application: scope.target_application.as_deref(),
                };
                let mut url = config.origin.clone();
                url.set_path("/tokens/2021-03-01/restrictedDataToken");
                let start = Instant::now();
                let response = config
                    .http
                    .post(url)
                    .header("x-amz-access-token", token)
                    .json(&body)
                    .send()
                    .await
                    .map_err(transport)?;
                let response: RdtResponse = read_response(response).await?;
                expiring_token(response.restricted_data_token, response.expires_in, start)
            }
            .boxed()
        })
        .await
    }

    async fn scope_slot(&self, scope: &RestrictedScope) -> Result<ScopeLease, AuthError> {
        loop {
            // Register before checking capacity; releases cannot race this wait.
            let notified = self.capacity.notified();
            tokio::pin!(notified);
            notified.as_mut().enable();
            let slot = {
                let mut cache = self.restricted.lock().map_err(|_| AuthError::Transport)?;
                cache.clock = cache.clock.wrapping_add(1);
                let touched = cache.clock;
                if !cache.entries.contains_key(scope)
                    && cache.entries.len() >= SCOPE_LIMIT
                    && let Some(oldest) = cache
                        .entries
                        .iter()
                        .filter(|(_, entry)| Arc::strong_count(&entry.slot) == 1)
                        .min_by_key(|(_, entry)| entry.touched)
                        .map(|(key, _)| key.clone())
                {
                    cache.entries.remove(&oldest);
                }
                if cache.entries.contains_key(scope) || cache.entries.len() < SCOPE_LIMIT {
                    let entry = cache
                        .entries
                        .entry(scope.clone())
                        .or_insert_with(|| ScopeEntry {
                            slot: Arc::new(Mutex::new(Slot::default())),
                            touched,
                        });
                    entry.touched = touched;
                    Some(entry.slot.clone())
                } else {
                    None
                }
            };
            if let Some(slot) = slot {
                return Ok(ScopeLease {
                    slot: Some(slot),
                    capacity: self.capacity.clone(),
                });
            }
            notified.await;
        }
    }
}

async fn cached(
    slot: Arc<Mutex<Slot>>,
    make: impl FnOnce() -> BoxFuture<'static, Result<Token, AuthError>>,
) -> Result<HeaderValue, AuthError> {
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

async fn base_token(config: Arc<Config>, slot: Arc<Mutex<Slot>>) -> Result<HeaderValue, AuthError> {
    if let Some(token) = &config.static_token {
        return Ok(token.clone());
    }
    cached(slot, move || {
        async move {
            let fields = match &config.credentials {
                Credentials::RefreshToken {
                    client_id,
                    client_secret,
                    refresh_token,
                } => vec![
                    ("grant_type", "refresh_token"),
                    ("client_id", client_id),
                    ("client_secret", client_secret),
                    ("refresh_token", refresh_token),
                ],
                Credentials::ClientCredentials {
                    client_id,
                    client_secret,
                    scope,
                } => vec![
                    ("grant_type", "client_credentials"),
                    ("client_id", client_id),
                    ("client_secret", client_secret),
                    ("scope", scope),
                ],
                Credentials::AccessToken(_) => unreachable!(),
            };
            let start = Instant::now();
            let response = config
                .http
                .post(config.lwa_endpoint.clone())
                .form(&fields)
                .send()
                .await
                .map_err(transport)?;
            let response: LwaResponse = read_response(response).await?;
            if !response.token_type.eq_ignore_ascii_case("bearer") {
                return Err(AuthError::InvalidResponse);
            }
            expiring_token(response.access_token, response.expires_in, start)
        }
        .boxed()
    })
    .await
}

fn endpoint(value: &str, origin: bool) -> Result<Url, AuthError> {
    let (scheme, rest) = value.split_once("://").ok_or(AuthError::InvalidConfig)?;
    let (authority, path) = rest.split_once('/').unwrap_or((rest, ""));
    if !matches!(scheme, "https" | "http")
        || authority.is_empty()
        || authority.contains('@')
        || (origin && !path.is_empty())
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
        || (origin && url.path() != "/")
    {
        return Err(AuthError::InvalidConfig);
    }
    Ok(url)
}

fn canonical_scope(scope: &RestrictedScope) -> Result<RestrictedScope, AuthError> {
    if !(1..=50).contains(&scope.resources.len())
        || scope
            .target_application
            .as_ref()
            .is_some_and(|value| value.trim().is_empty())
    {
        return Err(AuthError::InvalidConfig);
    }
    let mut scope = scope.clone();
    for resource in &mut scope.resources {
        if !matches!(resource.method.as_str(), "GET" | "PUT" | "POST" | "DELETE")
            || !resource.path.starts_with('/')
            || resource.path.starts_with("//")
            || resource
                .path
                .chars()
                .any(|c| c.is_whitespace() || c.is_control() || matches!(c, '\\' | '?' | '#'))
            || resource
                .data_elements
                .iter()
                .any(|value| value.trim().is_empty())
        {
            return Err(AuthError::InvalidConfig);
        }
        let path = resource.path.as_bytes();
        for (index, byte) in path.iter().enumerate() {
            if *byte == b'%'
                && !path
                    .get(index + 1..index + 3)
                    .is_some_and(|bytes| bytes.iter().all(u8::is_ascii_hexdigit))
            {
                return Err(AuthError::InvalidConfig);
            }
        }
        resource.data_elements.sort();
        resource.data_elements.dedup();
    }
    scope.resources.sort();
    scope.resources.dedup();
    Ok(scope)
}

fn header_token(value: &str) -> Result<HeaderValue, AuthError> {
    if value.trim().is_empty() {
        return Err(AuthError::InvalidResponse);
    }
    let mut token = HeaderValue::from_str(value).map_err(|_| AuthError::InvalidResponse)?;
    token.set_sensitive(true);
    Ok(token)
}

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
        value: header_token(&value)?,
        expires_at,
        refresh_at,
    })
}

async fn read_response<T: serde::de::DeserializeOwned>(
    response: reqwest::Response,
) -> Result<T, AuthError> {
    if !response.status().is_success() {
        return Err(AuthError::Rejected(response.status().as_u16()));
    }
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
    serde_json::from_slice(&body).map_err(|_| AuthError::InvalidResponse)
}

fn transport(error: reqwest::Error) -> AuthError {
    if error.is_timeout() {
        AuthError::Timeout
    } else {
        AuthError::Transport
    }
}

#[derive(Deserialize)]
struct LwaResponse {
    access_token: String,
    token_type: String,
    expires_in: u64,
}
#[derive(Deserialize)]
struct RdtResponse {
    #[serde(rename = "restrictedDataToken")]
    restricted_data_token: String,
    #[serde(rename = "expiresIn")]
    expires_in: u64,
}
#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct WireResource<'a> {
    method: &'a str,
    path: &'a str,
    data_elements: &'a [String],
}
#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct WireScope<'a> {
    restricted_resources: &'a [WireResource<'a>],
    #[serde(skip_serializing_if = "Option::is_none")]
    target_application: Option<&'a str>,
}
