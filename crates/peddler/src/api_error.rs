//! Opt-in status classification that retains the complete original response.

use crate::Response;
use std::fmt;

pub struct ApiError {
    pub response: Response,
    pub code: Option<String>,
    pub request_id: Option<String>,
}

impl fmt::Debug for ApiError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("ApiError")
            .field("status", &self.response.status)
            .finish_non_exhaustive()
    }
}

impl fmt::Display for ApiError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "API response status {}", self.response.status)
    }
}

impl std::error::Error for ApiError {}

impl Response {
    pub fn error_for_status(self) -> Result<Self, ApiError> {
        if (200..=299).contains(&self.status) {
            return Ok(self);
        }
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
            response: self,
            code,
            request_id,
        })
    }
}
