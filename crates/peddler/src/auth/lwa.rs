//! The three Login with Amazon grants, one request each.
use super::{AuthError, check_lifetime, check_token, endpoint, read_response, transport};
use crate::{Pool, url};
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
/// `refresh_token` is present when LWA sends one.
#[derive(Clone, Deserialize)]
pub struct LwaTokens {
    pub access_token: String,
    pub refresh_token: Option<String>,
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
        let pool = Pool::new().map_err(|_| AuthError::Transport)?;
        Self::with_pool(&pool, client_id, client_secret, lwa_endpoint, timeout)
    }

    /// Like `with_config`, on a connection pool shared with other clients.
    pub fn with_pool(
        pool: &Pool,
        client_id: &str,
        client_secret: &str,
        lwa_endpoint: &str,
        timeout: Duration,
    ) -> Result<Self, AuthError> {
        if client_id.trim().is_empty()
            || client_secret.trim().is_empty()
            || timeout.is_zero()
            || Instant::now().checked_add(timeout).is_none()
        {
            return Err(AuthError::InvalidConfig);
        }
        Ok(Self {
            config: Arc::new(Config {
                http: pool.http.clone(),
                endpoint: endpoint(lwa_endpoint)?,
                client_id: client_id.into(),
                client_secret: client_secret.into(),
                timeout,
            }),
        })
    }

    /// Exchange a seller's refresh token for an access token.
    pub async fn refresh(&self, refresh_token: &str) -> Result<LwaTokens, AuthError> {
        if refresh_token.trim().is_empty() {
            return Err(AuthError::InvalidConfig);
        }
        self.grant(&[
            ("grant_type", "refresh_token"),
            ("client_id", &self.config.client_id),
            ("client_secret", &self.config.client_secret),
            ("refresh_token", refresh_token),
        ])
        .await
    }

    /// Request an access token for grantless operations.
    pub async fn client_credentials(&self, scope: &str) -> Result<LwaTokens, AuthError> {
        if scope.trim().is_empty() {
            return Err(AuthError::InvalidConfig);
        }
        self.grant(&[
            ("grant_type", "client_credentials"),
            ("client_id", &self.config.client_id),
            ("client_secret", &self.config.client_secret),
            ("scope", scope),
        ])
        .await
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
        let tokens = self.grant(&fields).await?;
        if tokens.refresh_token.is_none() {
            return Err(AuthError::InvalidResponse);
        }
        Ok(tokens)
    }

    /// One POST under one deadline that also covers the body. Never retried.
    async fn grant(&self, fields: &[(&str, &str)]) -> Result<LwaTokens, AuthError> {
        let start = Instant::now();
        let deadline = start
            .checked_add(self.config.timeout)
            .ok_or(AuthError::InvalidConfig)?;
        tokio::time::timeout_at(deadline, async {
            let response = self
                .config
                .http
                .post(self.config.endpoint.clone())
                .timeout(self.config.timeout)
                .form(fields)
                .send()
                .await
                .map_err(transport)?;
            let tokens: LwaTokens = read_response(response, deadline).await?;
            if !tokens.token_type.eq_ignore_ascii_case("bearer") {
                return Err(AuthError::InvalidResponse);
            }
            check_token(&tokens.access_token)?;
            check_lifetime(tokens.expires_in, start)?;
            if let Some(token) = &tokens.refresh_token {
                check_token(token)?;
            }
            Ok(tokens)
        })
        .await
        .map_err(|_| AuthError::Timeout)?
    }
}

/// HTTP or HTTPS to any host, with a query if it has one.
fn validate_redirect_uri(value: &str) -> Result<(), AuthError> {
    match url::parse(value, &[]) {
        Some(("http" | "https", _)) if url::well_escaped(value) => Ok(()),
        _ => Err(AuthError::InvalidConfig),
    }
}
