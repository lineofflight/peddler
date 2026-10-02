use peddler::{Response, api_error::ApiErrorKind};

fn response(status: u16, body: &[u8]) -> Response {
    Response {
        status,
        headers: vec![
            ("X-AmZn-ReQuEsTiD".into(), "request-secret".into()),
            ("duplicate".into(), "first".into()),
            ("duplicate".into(), "second".into()),
        ],
        body: body.to_vec(),
    }
}

#[test]
fn success_retains_exact_response() {
    for status in [200, 204, 299] {
        let original = response(status, &[0, 255, 128]);
        let result = original.error_for_status().unwrap();
        assert_eq!(result.status, status);
        assert_eq!(result.body, [0, 255, 128]);
        assert_eq!(result.headers.len(), 3);
    }
}

#[test]
fn statuses_classify_without_requiring_json() {
    for (status, kind) in [
        (401, ApiErrorKind::Unauthorized),
        (403, ApiErrorKind::Forbidden),
        (404, ApiErrorKind::NotFound),
        (429, ApiErrorKind::Throttled),
        (500, ApiErrorKind::Server),
        (599, ApiErrorKind::Server),
        (400, ApiErrorKind::Client),
        (499, ApiErrorKind::Client),
        (100, ApiErrorKind::UnexpectedStatus),
        (302, ApiErrorKind::UnexpectedStatus),
        (600, ApiErrorKind::UnexpectedStatus),
    ] {
        let error = response(status, &[0, 255, 128])
            .error_for_status()
            .unwrap_err();
        assert_eq!(error.kind, kind);
        assert_eq!(error.response.status, status);
        assert_eq!(error.response.body, [0, 255, 128]);
        assert_eq!(error.response.headers[1].1, "first");
        assert_eq!(error.response.headers[2].1, "second");
        assert_eq!(error.code, None);
        assert_eq!(error.request_id.as_deref(), Some("request-secret"));
    }
}

#[test]
fn extracts_amazon_code_without_exposing_response_in_formatting() {
    let body = br#"{"errors":[{"code":"code-secret","message":"message-secret"}]}"#;
    let error = response(403, body).error_for_status().unwrap_err();
    assert_eq!(error.code.as_deref(), Some("code-secret"));
    assert_eq!(error.response.body, body);
    for rendered in [format!("{error}"), format!("{error:?}")] {
        for secret in [
            "code-secret",
            "message-secret",
            "request-secret",
            "duplicate",
        ] {
            assert!(!rendered.contains(secret), "{rendered}");
        }
        assert!(rendered.contains("403"));
    }
}

#[test]
fn malformed_or_missing_fields_are_optional() {
    for body in [
        b"{bad".as_slice(),
        b"null",
        br#"{"errors":[{"code":42}]}"#,
        br#"{"errors":[]}"#,
    ] {
        let error = Response {
            status: 400,
            headers: vec![],
            body: body.to_vec(),
        }
        .error_for_status()
        .unwrap_err();
        assert_eq!(error.code, None);
        assert_eq!(error.request_id, None);
        assert_eq!(error.kind, ApiErrorKind::Client);
    }
}
