use peddler::{
    Client, ClientConfig, Error,
    policy::{PolicyError, RetryPolicy},
};

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
fn the_default_is_no_retries_and_the_most_is_10() {
    assert_eq!(RetryPolicy::default().max_retries, 0);
    assert_eq!(RetryPolicy::default().validate(), Ok(()));
    let mut config = ClientConfig::new("https://example.com", "token");
    assert_eq!(config.retry.max_retries, 0);
    config.retry.max_retries = 10;
    assert!(Client::with_config(config).is_ok());
}
