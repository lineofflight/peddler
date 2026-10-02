use peddler::policy::{PolicyConfig, RateLimit, RequestPolicy, RetryPolicy};
use std::{collections::BTreeMap, time::Duration};
use tokio::time::{Instant, advance};

fn policy(rate: f64, burst: u32) -> RequestPolicy {
    RequestPolicy::new(PolicyConfig {
        rate_limits: BTreeMap::from([
            (
                "first".into(),
                RateLimit {
                    rate_per_second: rate,
                    burst,
                },
            ),
            (
                "second".into(),
                RateLimit {
                    rate_per_second: rate,
                    burst,
                },
            ),
        ]),
        ..PolicyConfig::default()
    })
    .unwrap()
}

fn waiting(policy: &RequestPolicy, operation: &'static str) -> tokio::task::JoinHandle<()> {
    let policy = policy.clone();
    tokio::spawn(async move { policy.acquire(operation).await })
}

#[tokio::test(start_paused = true)]
async fn burst_starts_full_and_refills_without_accumulating_over_capacity() {
    let policy = policy(2.0, 2);
    let start = Instant::now();
    policy.acquire("first").await;
    policy.acquire("first").await;
    assert_eq!(Instant::now(), start);
    policy.acquire("first").await;
    assert_eq!(Instant::now() - start, Duration::from_millis(500));
    advance(Duration::from_secs(10)).await;
    let start = Instant::now();
    policy.acquire("first").await;
    policy.acquire("first").await;
    policy.acquire("first").await;
    assert_eq!(Instant::now() - start, Duration::from_millis(500));
}

#[tokio::test(start_paused = true)]
async fn concurrent_clones_do_not_overspend_tokens() {
    let policy = policy(1.0, 1);
    policy.acquire("first").await;
    let tasks = (0..3)
        .map(|_| waiting(&policy, "first"))
        .collect::<Vec<_>>();
    tokio::task::yield_now().await;
    assert_eq!(tasks.iter().filter(|t| t.is_finished()).count(), 0);
    for count in 1..=3 {
        advance(Duration::from_secs(1)).await;
        tokio::task::yield_now().await;
        assert_eq!(tasks.iter().filter(|t| t.is_finished()).count(), count);
    }
    for task in tasks {
        task.await.unwrap();
    }
}

#[tokio::test(start_paused = true)]
async fn operation_buckets_and_separate_instances_are_independent() {
    let first = policy(1.0, 1);
    first.acquire("first").await;
    let start = Instant::now();
    first.acquire("second").await;
    policy(1.0, 1).acquire("first").await;
    for _ in 0..100 {
        first.acquire("unknown").await;
    }
    assert_eq!(Instant::now(), start);
}

#[tokio::test(start_paused = true)]
async fn cancelling_waiter_does_not_reserve_a_future_token() {
    let policy = policy(1.0, 1);
    policy.acquire("first").await;
    let cancelled = waiting(&policy, "first");
    tokio::task::yield_now().await;
    cancelled.abort();
    assert!(cancelled.await.unwrap_err().is_cancelled());
    let start = Instant::now();
    policy.acquire("first").await;
    assert_eq!(Instant::now() - start, Duration::from_secs(1));
}

#[tokio::test(start_paused = true)]
async fn observed_rate_accrues_at_old_rate_and_wakes_sleepers_without_changing_burst() {
    let policy = policy(1.0, 1);
    policy.acquire("first").await;
    let task = waiting(&policy, "first");
    tokio::task::yield_now().await;
    advance(Duration::from_millis(500)).await;
    policy.observe("first", &[("X-AMZN-ratelimit-LIMIT".into(), "2".into())]);
    tokio::task::yield_now().await;
    advance(Duration::from_millis(249)).await;
    tokio::task::yield_now().await;
    assert!(!task.is_finished());
    advance(Duration::from_millis(1)).await;
    task.await.unwrap();
    advance(Duration::from_secs(10)).await;
    policy.acquire("first").await;
    let start = Instant::now();
    policy.acquire("first").await;
    assert_eq!(Instant::now() - start, Duration::from_millis(500));
}

#[tokio::test(start_paused = true)]
async fn invalid_or_absent_rate_headers_are_ignored() {
    let policy = policy(1.0, 1);
    policy.acquire("first").await;
    for value in ["NaN", "inf", "0", "-1", "bad", "1e-300"] {
        policy.observe("first", &[("x-amzn-RateLimit-Limit".into(), value.into())]);
    }
    policy.observe("first", &[]);
    policy.observe("unknown", &[("x-amzn-RateLimit-Limit".into(), "10".into())]);
    let start = Instant::now();
    policy.acquire("first").await;
    assert_eq!(Instant::now() - start, Duration::from_secs(1));
}

#[test]
fn invalid_configuration_is_rejected_without_leaking_values() {
    for rate in [
        0.0,
        -1.0,
        f64::NAN,
        f64::INFINITY,
        f64::NEG_INFINITY,
        1e-300,
    ] {
        let result = RequestPolicy::new(PolicyConfig {
            rate_limits: BTreeMap::from([(
                "secret-operation".into(),
                RateLimit {
                    rate_per_second: rate,
                    burst: 1,
                },
            )]),
            ..PolicyConfig::default()
        });
        let error = result.err().expect("invalid rate accepted");
        assert!(!format!("{error}").contains("secret-operation"));
        assert!(!format!("{error:?}").contains("secret-operation"));
    }
    assert!(
        RequestPolicy::new(PolicyConfig {
            rate_limits: BTreeMap::from([(
                "first".into(),
                RateLimit {
                    rate_per_second: 1.0,
                    burst: 0
                }
            )]),
            ..PolicyConfig::default()
        })
        .is_err()
    );
    for retry in [
        RetryPolicy {
            max_retries: 11,
            ..RetryPolicy::default()
        },
        RetryPolicy {
            base_delay: Duration::ZERO,
            ..RetryPolicy::default()
        },
        RetryPolicy {
            max_delay: Duration::ZERO,
            ..RetryPolicy::default()
        },
        RetryPolicy {
            base_delay: Duration::from_secs(31),
            ..RetryPolicy::default()
        },
    ] {
        assert!(
            RequestPolicy::new(PolicyConfig {
                retry,
                ..PolicyConfig::default()
            })
            .is_err()
        );
    }
}

#[test]
fn default_disables_retries() {
    let policy = RequestPolicy::new(PolicyConfig::default()).unwrap();
    assert_eq!(policy.retry_delay("GET", 429, &[], 0), None);
}

#[test]
fn retries_only_safe_methods_and_selected_statuses_within_budget() {
    let policy = RequestPolicy::new(PolicyConfig {
        retry: RetryPolicy {
            max_retries: 2,
            ..RetryPolicy::default()
        },
        ..PolicyConfig::default()
    })
    .unwrap();
    for method in ["GET", "HEAD", "OPTIONS"] {
        for status in [429, 500, 502, 503, 504] {
            for (index, cap) in [(0, 200), (1, 400)] {
                let delay = policy.retry_delay(method, status, &[], index).unwrap();
                assert!(delay <= Duration::from_millis(cap));
            }
            assert_eq!(policy.retry_delay(method, status, &[], 2), None);
            assert_eq!(policy.retry_delay(method, status, &[], u32::MAX), None);
        }
        for status in [200, 301, 400, 401, 403, 404, 408, 501, 505] {
            assert_eq!(policy.retry_delay(method, status, &[], 0), None);
        }
    }
    for method in ["POST", "PATCH", "PUT", "DELETE", "TRACE", "get", "invalid"] {
        assert_eq!(policy.retry_delay(method, 429, &[], 0), None);
    }
}

#[test]
fn retry_after_seconds_never_retries_early_and_respects_maximum() {
    let policy = RequestPolicy::new(PolicyConfig {
        retry: RetryPolicy {
            max_retries: 10,
            ..RetryPolicy::default()
        },
        ..PolicyConfig::default()
    })
    .unwrap();
    for seconds in ["1", "30", " 1 "] {
        let delay = policy
            .retry_delay("GET", 429, &[("rEtRy-AfTeR".into(), seconds.into())], 0)
            .unwrap();
        assert!(delay >= Duration::from_secs(seconds.trim().parse().unwrap()));
    }
    for seconds in ["31", "18446744073709551615", "18446744073709551616"] {
        assert_eq!(
            policy.retry_delay("GET", 429, &[("Retry-After".into(), seconds.into())], 0),
            None
        );
    }
    for invalid in ["-1", "+1", "1.5", "NaN", "bad"] {
        assert!(
            policy
                .retry_delay("GET", 429, &[("Retry-After".into(), invalid.into())], 0)
                .unwrap()
                <= Duration::from_millis(200)
        );
    }
}
