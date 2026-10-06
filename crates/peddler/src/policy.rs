//! Conservative HTTP retry decisions.
//!
//! Callers own HTTP execution and the logical deadline covering all waits.
//! Configuration permits at most 10 retries. The delays are fixed.

use std::{
    fmt,
    time::{Duration, SystemTime},
};

/// The most the first retry waits. Each later one may wait twice as long.
const BASE_DELAY: Duration = Duration::from_millis(200);
/// The most any retry waits, and the longest `Retry-After` that is followed.
const MAX_DELAY: Duration = Duration::from_secs(30);

#[derive(Clone, Debug, Default)]
pub struct RetryPolicy {
    pub max_retries: u32,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PolicyError;

impl fmt::Display for PolicyError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("invalid request policy configuration")
    }
}

impl std::error::Error for PolicyError {}

impl RetryPolicy {
    pub fn validate(&self) -> Result<(), PolicyError> {
        if self.max_retries > 10 {
            return Err(PolicyError);
        }
        Ok(())
    }

    /// Index 0 is the first retry. Only GET, HEAD and OPTIONS are replayable.
    pub fn retry_delay(
        &self,
        method: &str,
        status: u16,
        headers: &[(String, String)],
        retry_index: u32,
    ) -> Option<Duration> {
        let cap = self.retry_cap(method, status, retry_index)?;
        let nanos = fastrand::u128(0..=cap.as_nanos());
        let jitter = Duration::new(
            (nanos / 1_000_000_000) as u64,
            (nanos % 1_000_000_000) as u32,
        );
        self.retry_delay_at(
            method,
            status,
            headers,
            retry_index,
            SystemTime::now(),
            jitter,
        )
    }

    fn retry_cap(&self, method: &str, status: u16, index: u32) -> Option<Duration> {
        if !matches!(method, "GET" | "HEAD" | "OPTIONS")
            || !matches!(status, 429 | 500 | 502 | 503 | 504)
            || index >= self.max_retries
        {
            return None;
        }
        Some(
            1u32.checked_shl(index)
                .and_then(|factor| BASE_DELAY.checked_mul(factor))
                .unwrap_or(MAX_DELAY)
                .min(MAX_DELAY),
        )
    }

    fn retry_delay_at(
        &self,
        method: &str,
        status: u16,
        headers: &[(String, String)],
        index: u32,
        now: SystemTime,
        jitter: Duration,
    ) -> Option<Duration> {
        let cap = self.retry_cap(method, status, index)?;
        let mut delay = jitter.min(cap);
        for (_, value) in headers
            .iter()
            .filter(|(name, _)| name.eq_ignore_ascii_case("Retry-After"))
        {
            let value = value.trim();
            let server_delay =
                if !value.is_empty() && value.bytes().all(|byte| byte.is_ascii_digit()) {
                    // Digit-only overflow is a valid excessive delay, never grounds
                    // for falling back to an earlier retry.
                    Some(Duration::from_secs(value.parse::<u64>().ok()?))
                } else {
                    httpdate::parse_http_date(value)
                        .ok()
                        .map(|date| date.duration_since(now).unwrap_or(Duration::ZERO))
                };
            if let Some(server_delay) = server_delay {
                if server_delay > MAX_DELAY {
                    return None;
                }
                delay = delay.max(server_delay);
            }
        }
        Some(delay)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::time::{Duration, SystemTime};

    fn retry() -> RetryPolicy {
        RetryPolicy { max_retries: 10 }
    }

    #[test]
    fn fixed_jitter_is_capped_by_exponential_bound() {
        let policy = retry();
        for (index, millis) in [
            (0, 200),
            (1, 400),
            (2, 800),
            (7, 25_600),
            (8, 30_000),
            (9, 30_000),
        ] {
            assert_eq!(
                policy.retry_delay_at(
                    "GET",
                    503,
                    &[],
                    index,
                    SystemTime::UNIX_EPOCH,
                    Duration::from_secs(60)
                ),
                Some(Duration::from_millis(millis))
            );
        }
        assert_eq!(
            policy.retry_delay_at("GET", 503, &[], 0, SystemTime::UNIX_EPOCH, Duration::ZERO),
            Some(Duration::ZERO)
        );
        assert_eq!(
            policy.retry_delay_at(
                "GET",
                503,
                &[],
                0,
                SystemTime::UNIX_EPOCH,
                Duration::from_millis(75)
            ),
            Some(Duration::from_millis(75))
        );
    }

    #[test]
    fn retry_after_dates_are_relative_to_fixed_now_and_never_early() {
        let policy = retry();
        let now = httpdate::parse_http_date("Wed, 21 Oct 2015 07:28:00 GMT").unwrap();
        for (date, expected) in [
            (
                "Wed, 21 Oct 2015 07:28:05 GMT",
                Some(Duration::from_secs(5)),
            ),
            (
                "Wed, 21 Oct 2015 07:28:30 GMT",
                Some(Duration::from_secs(30)),
            ),
            ("Wed, 21 Oct 2015 07:28:31 GMT", None),
            (
                "Wed, 21 Oct 2015 07:27:59 GMT",
                Some(Duration::from_millis(100)),
            ),
            ("not a date", Some(Duration::from_millis(100))),
        ] {
            assert_eq!(
                policy.retry_delay_at(
                    "HEAD",
                    429,
                    &[("Retry-After".into(), date.into())],
                    0,
                    now,
                    Duration::from_millis(100)
                ),
                expected
            );
        }
    }
}
