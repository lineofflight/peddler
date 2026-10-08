//! When a call is retried and how long it waits first, as Peddler 5 did.
//!
//! Only the number of retries is configurable, from 0 to 10. The rest is fixed:
//!
//! - A 429 is retried whatever the method: a throttled request was not processed. The
//!   wait is `1 / rate` seconds, doubling with each retry, plus up to 0.1 seconds,
//!   where `rate` is the requests per second Amazon documents for the operation. In
//!   Amazon's sandbox the first wait is 0.2 seconds instead.
//! - A 500, 502, 503 or 504, and an attempt that got no response, are retried for GET,
//!   HEAD and OPTIONS only: a write may have been processed. The wait is
//!   `2^(retry - 1) - 1` seconds plus up to 1 second, so up to 1, then 1 to 2, then
//!   3 to 4. A 429 of an operation without a documented rate waits like this too.
//! - A `Retry-After` header replaces the wait of its response.
//!
//! No wait has a ceiling.

use std::{
    fmt,
    time::{Duration, SystemTime},
};

/// The first wait after a 429 in Amazon's sandbox, in seconds, whatever the rate.
const SANDBOX_WAIT: f64 = 0.2;
/// The most that chance adds to the wait after a 429, in seconds.
const THROTTLE_JITTER: f64 = 0.1;

/// How often a client retries. The default is never. Nothing else about a retry is
/// configurable: the [module](self) says what is retried and how long each wait is.
#[derive(Clone, Debug, Default)]
pub struct RetryPolicy {
    /// The retries of one call, from 0 to 10.
    pub max_retries: u32,
}

/// A policy with more than 10 retries.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct PolicyError;

impl fmt::Display for PolicyError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str("invalid request policy configuration")
    }
}

impl std::error::Error for PolicyError {}

/// What a call brings to the decision.
#[derive(Clone, Copy, Debug)]
pub(crate) struct Call<'a> {
    /// The HTTP method, in uppercase.
    pub method: &'a str,
    /// The requests per second Amazon documents for the operation, if it does.
    pub rate: Option<f64>,
    /// Whether the client calls Amazon's sandbox.
    pub sandbox: bool,
}

/// How an attempt ended.
#[derive(Clone, Copy, Debug)]
pub(crate) enum Outcome<'a> {
    /// A response, whatever its status.
    Response {
        status: u16,
        headers: &'a [(String, String)],
    },
    /// No response: the connection failed or the attempt timed out.
    Failed,
}

impl RetryPolicy {
    /// Refuses more than 10 retries. A client checks its policy when it is built.
    pub fn validate(&self) -> Result<(), PolicyError> {
        if self.max_retries > 10 {
            return Err(PolicyError);
        }
        Ok(())
    }

    /// The wait before retry number `retry`, 1 being the first, or `None` when the
    /// call isn't retried.
    pub(crate) fn wait(
        &self,
        call: Call<'_>,
        outcome: Outcome<'_>,
        retry: u32,
    ) -> Option<Duration> {
        self.wait_at(call, outcome, retry, SystemTime::now(), fastrand::f64())
    }

    /// `random` is the part chance decides, from 0 up to 1. `now` is what a
    /// `Retry-After` date is measured from.
    fn wait_at(
        &self,
        call: Call<'_>,
        outcome: Outcome<'_>,
        retry: u32,
        now: SystemTime,
        random: f64,
    ) -> Option<Duration> {
        if retry == 0 || retry > self.max_retries {
            return None;
        }
        let safe = matches!(call.method, "GET" | "HEAD" | "OPTIONS");
        let throttled = match outcome {
            Outcome::Response { status: 429, .. } => true,
            Outcome::Response {
                status: 500 | 502 | 503 | 504,
                ..
            }
            | Outcome::Failed
                if safe =>
            {
                false
            }
            _ => return None,
        };
        if let Outcome::Response { headers, .. } = outcome
            && let Some(asked) = retry_after(headers, now)
        {
            return Some(asked);
        }
        let doubled = 2f64.powi(retry as i32 - 1);
        let seconds = match call.rate {
            Some(rate) if throttled => {
                let first = if call.sandbox {
                    SANDBOX_WAIT
                } else {
                    1.0 / rate
                };
                first * doubled + random * THROTTLE_JITTER
            }
            _ => doubled - 1.0 + random,
        };
        Some(Duration::try_from_secs_f64(seconds).unwrap_or(Duration::MAX))
    }
}

/// What `Retry-After` asks for: seconds, or the time left until a date, which is none
/// once the date has passed. The longest, if the header repeats. A value that is
/// neither is ignored.
fn retry_after(headers: &[(String, String)], now: SystemTime) -> Option<Duration> {
    headers
        .iter()
        .filter(|(name, _)| name.eq_ignore_ascii_case("Retry-After"))
        .filter_map(|(_, value)| {
            let value = value.trim();
            if !value.is_empty() && value.bytes().all(|byte| byte.is_ascii_digit()) {
                // Only digits that overflow fail to parse: more seconds than any wait.
                Some(value.parse().map_or(Duration::MAX, Duration::from_secs))
            } else {
                let date = httpdate::parse_http_date(value).ok()?;
                Some(date.duration_since(now).unwrap_or(Duration::ZERO))
            }
        })
        .max()
}

#[cfg(test)]
mod tests {
    use super::*;

    const EPOCH: SystemTime = SystemTime::UNIX_EPOCH;

    fn policy(max_retries: u32) -> RetryPolicy {
        RetryPolicy { max_retries }
    }

    fn call(method: &str, rate: Option<f64>) -> Call<'_> {
        Call {
            method,
            rate,
            sandbox: false,
        }
    }

    fn status(status: u16) -> Outcome<'static> {
        Outcome::Response {
            status,
            headers: &[],
        }
    }

    fn seconds(wait: Option<Duration>) -> f64 {
        wait.expect("retried").as_secs_f64()
    }

    fn close(actual: f64, expected: f64) -> bool {
        (actual - expected).abs() < 1e-6
    }

    #[test]
    fn a_429_waits_one_over_the_rate_and_doubles_plus_a_tenth_of_the_random_part() {
        let policy = policy(10);
        // v5: (1.0 / rate_limit) * 2.0**(iteration - 1) + rand * 0.1
        for (rate, random, waits) in [
            (0.5, 0.0, [2.0, 4.0, 8.0]),
            (0.5, 0.5, [2.05, 4.05, 8.05]),
            (2.0, 0.0, [0.5, 1.0, 2.0]),
            (80.0, 0.0, [0.0125, 0.025, 0.05]),
            (0.0167, 0.0, [1.0 / 0.0167, 2.0 / 0.0167, 4.0 / 0.0167]),
        ] {
            for (retry, expected) in (1..).zip(waits) {
                let wait =
                    policy.wait_at(call("GET", Some(rate)), status(429), retry, EPOCH, random);
                assert!(close(seconds(wait), expected), "{rate} {retry}: {wait:?}");
            }
        }
        // An operation limited to 1 request a minute waits a minute, then 2, then 4.
        let minute = policy.wait_at(call("GET", Some(0.0167)), status(429), 1, EPOCH, 0.0);
        assert!((59.0..61.0).contains(&seconds(minute)));
        // The tenth retry of the slowest documented rate still has a wait.
        let last = policy.wait_at(call("GET", Some(0.0056)), status(429), 10, EPOCH, 0.999);
        assert!(close(seconds(last), 512.0 / 0.0056 + 0.0999));
    }

    #[test]
    fn the_sandbox_starts_a_429_at_a_fifth_of_a_second_whatever_the_rate() {
        let policy = policy(3);
        for rate in [0.0167, 80.0] {
            let sandbox = Call {
                method: "GET",
                rate: Some(rate),
                sandbox: true,
            };
            for (retry, expected) in [(1, 0.2), (2, 0.4), (3, 0.8)] {
                let wait = policy.wait_at(sandbox, status(429), retry, EPOCH, 0.0);
                assert!(close(seconds(wait), expected), "{rate} {retry}: {wait:?}");
            }
        }
        // Without a rate the sandbox backs off as anything else does.
        let unrated = Call {
            method: "GET",
            rate: None,
            sandbox: true,
        };
        let wait = policy.wait_at(unrated, status(429), 3, EPOCH, 0.5);
        assert!(close(seconds(wait), 3.5));
    }

    #[test]
    fn a_failure_and_a_429_without_a_rate_wait_the_standard_backoff() {
        let policy = policy(10);
        // v5: 2.0**(iteration - 1) - 1 + rand
        let outcomes = [
            (None, status(429)),
            (None, status(500)),
            (None, status(502)),
            (None, status(503)),
            (None, status(504)),
            (None, Outcome::Failed),
            // A rate only sets the wait after a 429.
            (Some(0.0167), status(503)),
            (Some(0.0167), Outcome::Failed),
        ];
        for (rate, outcome) in outcomes {
            for (retry, base) in [(1, 0.0), (2, 1.0), (3, 3.0), (4, 7.0), (10, 511.0)] {
                for random in [0.0, 0.25, 0.999] {
                    let wait = policy.wait_at(call("GET", rate), outcome, retry, EPOCH, random);
                    assert!(
                        close(seconds(wait), base + random),
                        "{outcome:?} {retry}: {wait:?}"
                    );
                }
            }
        }
    }

    #[test]
    fn a_429_is_retried_for_any_method_and_a_failure_for_safe_ones_only() {
        let policy = policy(1);
        let failures = [
            status(500),
            status(502),
            status(503),
            status(504),
            Outcome::Failed,
        ];
        for method in ["GET", "HEAD", "OPTIONS"] {
            for outcome in failures.into_iter().chain([status(429)]) {
                assert!(
                    policy.wait(call(method, None), outcome, 1).is_some(),
                    "{method} {outcome:?}"
                );
            }
        }
        for method in ["POST", "PUT", "PATCH", "DELETE", "TRACE", "get"] {
            for rate in [None, Some(5.0)] {
                assert!(
                    policy.wait(call(method, rate), status(429), 1).is_some(),
                    "{method}"
                );
                for outcome in failures {
                    assert_eq!(
                        policy.wait(call(method, rate), outcome, 1),
                        None,
                        "{method} {outcome:?}"
                    );
                }
            }
        }
        // Nothing else is retried, whatever the method or its headers.
        let asked = [("Retry-After".to_owned(), "0".to_owned())];
        for method in ["GET", "POST"] {
            for code in [200, 204, 301, 400, 401, 403, 404, 408, 501, 505] {
                let outcome = Outcome::Response {
                    status: code,
                    headers: &asked,
                };
                assert_eq!(policy.wait(call(method, Some(5.0)), outcome, 1), None);
            }
        }
    }

    #[test]
    fn the_number_of_retries_is_the_only_limit() {
        assert_eq!(RetryPolicy::default().max_retries, 0);
        for outcome in [status(429), status(503), Outcome::Failed] {
            assert_eq!(
                RetryPolicy::default().wait(call("GET", Some(5.0)), outcome, 1),
                None
            );
            let policy = policy(2);
            assert!(policy.wait(call("GET", Some(5.0)), outcome, 1).is_some());
            assert!(policy.wait(call("GET", Some(5.0)), outcome, 2).is_some());
            assert_eq!(policy.wait(call("GET", Some(5.0)), outcome, 3), None);
            assert_eq!(policy.wait(call("GET", Some(5.0)), outcome, u32::MAX), None);
        }
        assert_eq!(policy(10).validate(), Ok(()));
        assert_eq!(policy(11).validate(), Err(PolicyError));
    }

    #[test]
    fn the_random_part_is_drawn_within_its_range() {
        let policy = policy(3);
        for _ in 0..200 {
            let throttled = seconds(policy.wait(call("POST", Some(5.0)), status(429), 2));
            assert!((0.4..0.5).contains(&throttled), "{throttled}");
            let failed = seconds(policy.wait(call("GET", Some(5.0)), Outcome::Failed, 3));
            assert!((3.0..4.0).contains(&failed), "{failed}");
        }
    }

    fn asking(status: u16, headers: &[(String, String)]) -> Outcome<'_> {
        Outcome::Response { status, headers }
    }

    fn header(value: &str) -> [(String, String); 1] {
        [("rEtRy-AfTeR".to_owned(), value.to_owned())]
    }

    #[test]
    fn retry_after_replaces_the_wait_of_its_response() {
        let policy = policy(10);
        let slow = call("GET", Some(0.0167));
        for (value, expected) in [
            ("0", 0),
            ("1", 1),
            (" 7 ", 7),
            ("120", 120),
            ("86400", 86400),
        ] {
            for (call, code) in [(slow, 429), (slow, 503), (call("POST", None), 429)] {
                for retry in [1, 5] {
                    let headers = header(value);
                    let wait = policy.wait_at(call, asking(code, &headers), retry, EPOCH, 0.9);
                    assert_eq!(wait, Some(Duration::from_secs(expected)), "{value} {code}");
                }
            }
        }
        // More seconds than a number holds is still a wait, not grounds to retry early.
        let headers = header("18446744073709551616");
        assert_eq!(
            policy.wait_at(slow, asking(429, &headers), 1, EPOCH, 0.0),
            Some(Duration::MAX)
        );
        // The header of a response that isn't retried changes nothing.
        let headers = header("0");
        assert_eq!(
            policy.wait_at(call("POST", None), asking(503, &headers), 1, EPOCH, 0.0),
            None
        );
    }

    #[test]
    fn a_retry_after_date_is_the_time_left_until_it() {
        let policy = policy(1);
        let now = httpdate::parse_http_date("Wed, 21 Oct 2015 07:28:00 GMT").unwrap();
        for (date, expected) in [
            ("Wed, 21 Oct 2015 07:28:05 GMT", 5),
            ("Wed, 21 Oct 2015 07:30:00 GMT", 120),
            ("Wed, 21 Oct 2015 07:27:59 GMT", 0),
        ] {
            let headers = header(date);
            let wait = policy.wait_at(call("GET", Some(0.5)), asking(429, &headers), 1, now, 0.5);
            assert_eq!(wait, Some(Duration::from_secs(expected)), "{date}");
        }
    }

    #[test]
    fn a_retry_after_that_is_neither_seconds_nor_a_date_is_ignored() {
        let policy = policy(1);
        for invalid in ["", "-1", "+1", "1.5", "NaN", "soon"] {
            let headers = header(invalid);
            let wait = policy.wait_at(call("GET", Some(0.5)), asking(429, &headers), 1, EPOCH, 0.0);
            assert_eq!(wait, Some(Duration::from_secs(2)), "{invalid:?}");
        }
        // The longest of a header that repeats.
        let headers = [
            ("retry-after".to_owned(), "3".to_owned()),
            ("retry-after".to_owned(), "soon".to_owned()),
            ("retry-after".to_owned(), "9".to_owned()),
        ];
        assert_eq!(
            policy.wait_at(call("GET", None), asking(503, &headers), 1, EPOCH, 0.0),
            Some(Duration::from_secs(9))
        );
    }
}
