//! Authorization-code onboarding, independent of seller credentials and caches.
use super::{AuthError, endpoint, expiring_token, header_token, read_response, transport};
use reqwest::Url;
use serde::Deserialize;
use std::{fmt, sync::Arc, time::Duration};
use tokio::time::Instant;

struct Config {
    http: reqwest::Client,
    endpoint: Url,
    client_id: String,
    client_secret: String,
    timeout: Duration,
}

/// Clones share the HTTP connection pool. Construction performs no HTTP.
#[derive(Clone)]
pub struct LwaClient {
    config: Arc<Config>,
}
impl fmt::Debug for LwaClient {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("LwaClient").finish_non_exhaustive()
    }
}

/// Explicit fields expose credentials; formatting always redacts both tokens.
#[derive(Clone, Deserialize)]
pub struct LwaTokens {
    pub access_token: String,
    pub refresh_token: String,
    pub token_type: String,
    pub expires_in: u64,
}
impl fmt::Debug for LwaTokens {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("LwaTokens")
            .field("access_token", &"[redacted]")
            .field("refresh_token", &"[redacted]")
            .finish_non_exhaustive()
    }
}

impl LwaClient {
    pub fn new(client_id: &str, client_secret: &str) -> Result<Self, AuthError> {
        Self::with_config(
            client_id,
            client_secret,
            crate::DEFAULT_LWA_ENDPOINT,
            Duration::from_secs(30),
        )
    }

    pub fn with_config(
        client_id: &str,
        client_secret: &str,
        lwa_endpoint: &str,
        timeout: Duration,
    ) -> Result<Self, AuthError> {
        Self::build(client_id, client_secret, lwa_endpoint, timeout, None)
    }

    /// Like `with_config`, for a wrapper that identifies itself with its own User-Agent.
    pub fn with_user_agent(
        client_id: &str,
        client_secret: &str,
        lwa_endpoint: &str,
        timeout: Duration,
        user_agent: &str,
    ) -> Result<Self, AuthError> {
        reqwest::header::HeaderValue::from_str(user_agent).map_err(|_| AuthError::InvalidConfig)?;
        Self::build(
            client_id,
            client_secret,
            lwa_endpoint,
            timeout,
            Some(user_agent),
        )
    }

    fn build(
        client_id: &str,
        client_secret: &str,
        lwa_endpoint: &str,
        timeout: Duration,
        user_agent: Option<&str>,
    ) -> Result<Self, AuthError> {
        if client_id.trim().is_empty()
            || client_secret.trim().is_empty()
            || timeout.is_zero()
            || Instant::now().checked_add(timeout).is_none()
        {
            return Err(AuthError::InvalidConfig);
        }
        let endpoint = endpoint(lwa_endpoint, false)?;
        let http = crate::build_http(timeout, user_agent).map_err(transport)?;
        Ok(Self {
            config: Arc::new(Config {
                http,
                endpoint,
                client_id: client_id.into(),
                client_secret: client_secret.into(),
                timeout,
            }),
        })
    }

    /// Omit redirect_uri only for SDK-originated grants. Otherwise pass the
    /// exact URI used during authorization. Codes are never retried.
    pub async fn exchange_authorization_code(
        &self,
        code: &str,
        redirect_uri: Option<&str>,
    ) -> Result<LwaTokens, AuthError> {
        if code.trim().is_empty() {
            return Err(AuthError::InvalidConfig);
        }
        if let Some(uri) = redirect_uri {
            validate_redirect_uri(uri)?;
        }
        let mut fields = vec![
            ("grant_type", "authorization_code"),
            ("code", code),
            ("client_id", self.config.client_id.as_str()),
            ("client_secret", self.config.client_secret.as_str()),
        ];
        if let Some(uri) = redirect_uri {
            fields.push(("redirect_uri", uri));
        }
        let start = Instant::now();
        tokio::time::timeout(self.config.timeout, async {
            let response = self
                .config
                .http
                .post(self.config.endpoint.clone())
                .form(&fields)
                .send()
                .await
                .map_err(transport)?;
            let tokens: LwaTokens = read_response(response).await?;
            if !tokens.token_type.eq_ignore_ascii_case("bearer") {
                return Err(AuthError::InvalidResponse);
            }
            expiring_token(tokens.access_token.clone(), tokens.expires_in, start)?;
            header_token(&tokens.refresh_token)?;
            Ok(tokens)
        })
        .await
        .map_err(|_| AuthError::Timeout)?
    }
}

fn validate_redirect_uri(value: &str) -> Result<(), AuthError> {
    let (scheme, rest) = value.split_once("://").ok_or(AuthError::InvalidConfig)?;
    let authority = rest.split(['/', '?', '#']).next().unwrap_or("");
    if !matches!(scheme, "http" | "https") || authority.is_empty() || authority.contains('@') {
        return Err(AuthError::InvalidConfig);
    }
    if value
        .chars()
        .any(|c| c.is_whitespace() || c.is_control() || c == '\\')
    {
        return Err(AuthError::InvalidConfig);
    }
    let url = Url::parse(value).map_err(|_| AuthError::InvalidConfig)?;
    if !matches!(url.scheme(), "http" | "https")
        || url.host_str().is_none()
        || !url.username().is_empty()
        || url.password().is_some()
        || url.fragment().is_some()
    {
        return Err(AuthError::InvalidConfig);
    }
    let bytes = value.as_bytes();
    for (index, byte) in bytes.iter().enumerate() {
        if *byte == b'%'
            && !bytes
                .get(index + 1..index + 3)
                .is_some_and(|v| v.iter().all(u8::is_ascii_hexdigit))
        {
            return Err(AuthError::InvalidConfig);
        }
    }
    Ok(())
}
