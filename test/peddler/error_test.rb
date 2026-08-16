# frozen_string_literal: true

require "helper"

module Peddler
  class ErrorTest < Minitest::Test
    def test_invalid_input
      response = mock_http_response(
        body: '{"errors":[{"code":"InvalidInput","message":"InvalidInput"}]}',
        status: 400,
      )
      error = Error.build(response)

      assert_kind_of(Errors::InvalidInput, error)
    end

    def test_not_found
      response = mock_http_response(
        body: '{"errors":[{"code":"NotFound","message":"NotFound"}]}',
        status: 404,
      )
      error = Error.build(response)

      assert_kind_of(Errors::NotFound, error)
    end

    def test_quota_exceeded
      response = mock_http_response(
        body: '{"errors":[{"code":"QuotaExceeded","message":"You exceeded your quota for the requested resource."}]}',
        status: 429,
      )
      error = Error.build(response)

      assert_kind_of(Errors::QuotaExceeded, error)
    end

    def test_unauthorized
      response = mock_http_response(
        body: '{"errors":[{"code":"Unauthorized","message":"Access to requested resource is denied."}]}',
        status: 403,
      )
      error = Error.build(response)

      assert_kind_of(Errors::Unauthorized, error)
    end

    def test_unsupported_grant_type
      response = mock_http_response(
        body: '{"error":"unsupported_grant_type","error_description":"The authorization grant type is not supported by the authorization server"}',
      )
      error = Error.build(response)

      assert_kind_of(Errors::UnsupportedGrantType, error)
    end

    def test_invalid_grant
      response = mock_http_response(
        body: '{"error_description":"The request has an invalid grant parameter : refresh_token. User may have unauthorized or didn\'t grant the permission.","error":"invalid_grant"}',
      )
      error = Error.build(response)

      assert_kind_of(Errors::InvalidGrant, error)
    end

    def test_invalid_request
      response = mock_http_response(
        body: '{"error":"invalid_request","error_description":"The request is missing a required parameter : refresh_token"}',
      )
      error = Error.build(response)

      assert_kind_of(Errors::InvalidRequest, error)
    end

    def test_access_denied
      response = mock_http_response(
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Error><Code>AccessDenied</Code><Message>Request has expired</Message><X-Amz-Expires>300</X-Amz-Expires><Expires>2025-06-03T12:26:02Z</Expires><ServerTime>2025-06-03T14:34:02Z</ServerTime><RequestId>123</RequestId><HostId>123</HostId></Error>",
        status: 403,
      )
      error = Error.build(response)

      assert_kind_of(Errors::AccessDenied, error)
    end

    def test_other_api_error
      response = mock_http_response(body: '{"errors":[{"code":"OtherError","message":"OtherError"}]}')
      error = Error.build(response)

      assert_includes(Errors.constants, :OtherError)
      assert_kind_of(Errors::OtherError, error)
    end

    def test_other_token_error
      response = mock_http_response(body: '{"error":"other_error","error_description":"OtherError"}')
      error = Error.build(response)

      assert_includes(Errors.constants, :OtherError)
      assert_kind_of(Errors::OtherError, error)
    end

    def test_normalized_screaming_snake_case
      response = mock_http_response(body: '{"errors":[{"code":"NOT_FOUND","message":"Resource not found"}]}')
      error = Error.build(response)

      assert_kind_of(Errors::NotFound, error)
    end

    def test_invalid_class_name_falls_back_to_base_error
      response = mock_http_response(body: '{"errors":[{"code":"400","message":"Invalid Input"}]}')
      error = Error.build(response)

      assert_instance_of(Error, error)
      assert_equal("Invalid Input", error.message)
    end

    def test_deconstruct_keys_returns_status
      response = mock_http_response(
        body: '{"errors":[{"code":"QuotaExceeded","message":"You exceeded your quota."}]}',
        status: 429,
      )
      error = Error.build(response)

      assert_equal({ status: 429 }, error.deconstruct_keys(nil))
    end

    def test_deconstruct_keys_without_response
      error = Error.new("boom")

      assert_nil(error.deconstruct_keys(nil)[:status])
    end

    def test_status_returns_http_status_code_as_integer
      response = mock_http_response(
        body: '{"errors":[{"code":"QuotaExceeded","message":"You exceeded your quota."}]}',
        status: 429,
      )
      error = Error.build(response)

      assert_instance_of(Integer, error.status)
      assert_equal(429, error.status)
    end

    def test_status_without_response
      error = Error.new("boom")

      assert_nil(error.status)
    end

    def test_pattern_matches_status_range
      response = mock_http_response(
        body: '{"errors":[{"code":"InternalFailure","message":"We encountered an internal error."}]}',
        status: 503,
      )
      error = Error.build(response)

      matched = case error
                in status: 500..599 then true
                else false
                end

      assert(matched)
    end

    def test_unparseable_body_falls_back_to_base_error_with_status_message
      response = mock_http_response(body: "invalid xml content")
      error = Error.build(response)

      assert_instance_of(Error, error)
      assert_equal("400 Bad Request", error.message)
    end

    def test_non_object_json_body_falls_back_to_base_error
      # A body can be valid JSON without being an object, e.g. a bare number from a proxy
      response = mock_http_response(body: "503", status: 503)
      error = Error.build(response)

      assert_instance_of(Error, error)
      assert_equal("503 Service Unavailable", error.message)
    end

    private

    def mock_http_response(**options)
      default_options = {
        status: 400,
        version: "1.1",
        request: nil,
      }
      HTTP::Response.new(**default_options.merge(options))
    end
  end
end
