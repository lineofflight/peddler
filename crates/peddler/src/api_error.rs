//! Opt-in status classification that retains the complete original response.

use crate::Response;
use std::fmt;

/// A response outside 2xx and what Amazon said of it. [`Response::error_for_status`]
/// builds it. Debug and Display show the status only.
pub struct ApiError {
    /// The whole response, as it arrived.
    pub response: Response,
    /// The `code` of the first entry in `errors`.
    pub code: Option<String>,
    /// The `x-amzn-RequestId` header.
    pub request_id: Option<String>,
    /// The `message` of the first entry in `errors`, as Amazon sent it.
    pub message: Option<String>,
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
    /// The response when its status is 2xx, and an [`ApiError`] that keeps it otherwise.
    // The error carries the whole response, which is the point of it.
    #[allow(clippy::result_large_err)]
    pub fn error_for_status(self) -> Result<Self, ApiError> {
        if (200..=299).contains(&self.status) {
            return Ok(self);
        }
        let body = serde_json::from_slice::<serde_json::Value>(&self.body).ok();
        let first = body
            .as_ref()
            .and_then(|value| value.get("errors")?.as_array()?.first());
        let field = |name| Some(first?.get(name)?.as_str()?.to_owned());
        let (code, message) = (field("code"), field("message"));
        let request_id = self
            .headers
            .iter()
            .find(|(name, _)| name.eq_ignore_ascii_case("x-amzn-requestid"))
            .map(|(_, value)| value.clone());
        Err(ApiError {
            response: self,
            code,
            request_id,
            message,
        })
    }
}
