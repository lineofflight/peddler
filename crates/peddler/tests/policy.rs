use peddler::{
    Client, ClientConfig, Error,
    policy::{PolicyError, RetryPolicy},
};
use std::time::Duration;

#[test]
fn invalid_configuration_is_rejected() {
    let retry = RetryPolicy { max_retries: 11 };
    assert_eq!(retry.validate(), Err(PolicyError));
    let mut config = ClientConfig::new("https://example.com", "token");
    config.retry = retry;
    assert_eq!(
        Client::with_config(config).unwrap_err(),
        Error::InvalidRequest
    );
}

#[test]
fn default_disables_retries() {
    let policy = RetryPolicy::default();
    assert_eq!(policy.validate(), Ok(()));
    assert_eq!(policy.retry_delay("GET", 429, &[], 0), None);
}

#[test]
fn retries_only_safe_methods_and_selected_statuses_within_budget() {
    let policy = RetryPolicy { max_retries: 2 };
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
    let policy = RetryPolicy { max_retries: 10 };
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
