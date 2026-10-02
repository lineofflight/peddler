//! Opt-in status classification that retains the complete original response.

use crate::Response;
use std::fmt;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ApiErrorKind {
    Unauthorized,
    Forbidden,
    NotFound,
    Throttled,
    Server,
    Client,
    UnexpectedStatus,
}

pub struct ApiError {
    pub kind: ApiErrorKind,
    pub response: Response,
    pub code: Option<String>,
    pub request_id: Option<String>,
}

impl fmt::Debug for ApiError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("ApiError")
            .field("kind", &self.kind)
            .field("status", &self.response.status)
            .finish_non_exhaustive()
    }
}

impl fmt::Display for ApiError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "API response status {} ({:?})",
            self.response.status, self.kind
        )
    }
}

impl std::error::Error for ApiError {}

impl Response {
    pub fn error_for_status(self) -> Result<Self, ApiError> {
        let kind = match self.status {
            200..=299 => return Ok(self),
            401 => ApiErrorKind::Unauthorized,
            403 => ApiErrorKind::Forbidden,
            404 => ApiErrorKind::NotFound,
            429 => ApiErrorKind::Throttled,
            400..=499 => ApiErrorKind::Client,
            500..=599 => ApiErrorKind::Server,
            _ => ApiErrorKind::UnexpectedStatus,
        };
        let code = serde_json::from_slice::<serde_json::Value>(&self.body)
            .ok()
            .and_then(|value| {
                value
                    .get("errors")?
                    .as_array()?
                    .first()?
                    .get("code")?
                    .as_str()
                    .map(str::to_owned)
            });
        let request_id = self
            .headers
            .iter()
            .find(|(name, _)| name.eq_ignore_ascii_case("x-amzn-requestid"))
            .map(|(_, value)| value.clone());
        Err(ApiError {
            kind,
            response: self,
            code,
            request_id,
        })
    }
}
