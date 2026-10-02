//! Independent operation token buckets and conservative HTTP retry decisions.
//!
//! Callers own HTTP execution and the logical deadline covering all waits.
//! Configuration permits at most 10 retries, positive delays and max >= base.

use std::{
    collections::BTreeMap,
    fmt,
    sync::{Arc, Mutex},
    time::{Duration, SystemTime},
};
use tokio::{sync::Notify, time::Instant};

#[derive(Clone, Copy, Debug)]
pub struct RateLimit {
    pub rate_per_second: f64,
    pub burst: u32,
}

#[derive(Clone, Debug)]
pub struct RetryPolicy {
    pub max_retries: u32,
    pub base_delay: Duration,
    pub max_delay: Duration,
}

impl Default for RetryPolicy {
    fn default() -> Self {
        Self {
            max_retries: 0,
            base_delay: Duration::from_millis(200),
            max_delay: Duration::from_secs(30),
        }
    }
}

#[derive(Clone, Debug, Default)]
pub struct PolicyConfig {
    pub retry: RetryPolicy,
    pub rate_limits: BTreeMap<String, RateLimit>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PolicyError;

impl fmt::Display for PolicyError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("invalid request policy configuration")
    }
}

impl std::error::Error for PolicyError {}

/// Clones share buckets; separate constructions never share token state.
#[derive(Clone)]
pub struct RequestPolicy {
    retry: RetryPolicy,
    buckets: Arc<BTreeMap<String, Bucket>>,
}

struct Bucket {
    state: Mutex<BucketState>,
    changed: Notify,
}

struct BucketState {
    rate: f64,
    burst: f64,
    tokens: f64,
    updated: Instant,
}

impl BucketState {
    fn refill(&mut self, now: Instant) {
        self.tokens = (self.tokens + now.duration_since(self.updated).as_secs_f64() * self.rate)
            .min(self.burst);
        self.updated = now;
    }
}

fn valid_rate(rate: f64) -> bool {
    rate.is_finite()
        && rate > 0.0
        && Duration::try_from_secs_f64(1.0 / rate)
            .ok()
            .is_some_and(|wait| Instant::now().checked_add(wait).is_some())
}

impl RequestPolicy {
    pub fn new(config: PolicyConfig) -> Result<Self, PolicyError> {
        if config.retry.max_retries > 10
            || config.retry.base_delay.is_zero()
            || config.retry.max_delay.is_zero()
            || config.retry.max_delay < config.retry.base_delay
            || config
                .rate_limits
                .values()
                .any(|limit| limit.burst == 0 || !valid_rate(limit.rate_per_second))
        {
            return Err(PolicyError);
        }
        let buckets = config
            .rate_limits
            .into_iter()
            .map(|(operation, limit)| {
                (
                    operation,
                    Bucket {
                        state: Mutex::new(BucketState {
                            rate: limit.rate_per_second,
                            burst: f64::from(limit.burst),
                            tokens: f64::from(limit.burst),
                            updated: Instant::now(),
                        }),
                        changed: Notify::new(),
                    },
                )
            })
            .collect();
        Ok(Self {
            retry: config.retry,
            buckets: Arc::new(buckets),
        })
    }

    /// Waiting never reserves future tokens, so cancellation needs no cleanup.
    pub async fn acquire(&self, operation: &str) {
        let Some(bucket) = self.buckets.get(operation) else {
            return;
        };
        loop {
            let changed = bucket.changed.notified();
            tokio::pin!(changed);
            // Register before inspecting state so an update cannot be missed.
            changed.as_mut().enable();
            let wait = {
                let mut state = bucket.state.lock().unwrap_or_else(|e| e.into_inner());
                state.refill(Instant::now());
                if state.tokens >= 1.0 {
                    state.tokens -= 1.0;
                    return;
                }
                let seconds = (1.0 - state.tokens) / state.rate;
                // Bound each timer even when a valid rate implies a very long
                // wait. Recheck tokens and observations after each timer.
                Duration::from_secs_f64(seconds.min(86_400.0)).max(Duration::from_nanos(1))
            };
            let sleep = tokio::time::sleep(wait);
            tokio::pin!(sleep);
            let _ = futures_util::future::select(sleep, changed).await;
        }
    }

    /// Only configured buckets change; observed rate never changes the burst.
    pub fn observe(&self, operation: &str, headers: &[(String, String)]) {
        let Some(bucket) = self.buckets.get(operation) else {
            return;
        };
        let Some(rate) = headers
            .iter()
            .filter(|(name, _)| name.eq_ignore_ascii_case("x-amzn-RateLimit-Limit"))
            .find_map(|(_, value)| {
                value
                    .trim()
                    .parse::<f64>()
                    .ok()
                    .filter(|rate| valid_rate(*rate))
            })
        else {
            return;
        };
        {
            let mut state = bucket.state.lock().unwrap_or_else(|e| e.into_inner());
            state.refill(Instant::now());
            state.rate = rate;
        }
        bucket.changed.notify_waiters();
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
            || index >= self.retry.max_retries
        {
            return None;
        }
        Some(
            self.retry
                .base_delay
                .checked_mul(1 << index)
                .unwrap_or(self.retry.max_delay)
                .min(self.retry.max_delay),
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
                if server_delay > self.retry.max_delay {
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

    fn retry(base: Duration, max: Duration) -> RequestPolicy {
        RequestPolicy::new(PolicyConfig {
            retry: RetryPolicy {
                max_retries: 10,
                base_delay: base,
                max_delay: max,
            },
            ..PolicyConfig::default()
        })
        .unwrap()
    }

    #[test]
    fn fixed_jitter_is_capped_by_exponential_bound() {
        let policy = retry(Duration::from_millis(200), Duration::from_secs(1));
        for (index, millis) in [(0, 200), (1, 400), (2, 800), (3, 1000), (9, 1000)] {
            assert_eq!(
                policy.retry_delay_at(
                    "GET",
                    503,
                    &[],
                    index,
                    SystemTime::UNIX_EPOCH,
                    Duration::from_secs(2)
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
        let policy = retry(Duration::from_millis(200), Duration::from_secs(30));
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

    #[test]
    fn exponential_and_jitter_support_largest_duration_without_overflow() {
        let policy = retry(Duration::MAX, Duration::MAX);
        assert_eq!(
            policy.retry_delay_at("GET", 500, &[], 9, SystemTime::UNIX_EPOCH, Duration::MAX),
            Some(Duration::MAX)
        );
        for _ in 0..32 {
            assert!(policy.retry_delay("GET", 500, &[], 9).unwrap() <= Duration::MAX);
        }
    }
}
