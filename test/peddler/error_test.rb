# frozen_string_literal: true

require "helper"
require "peddler/error"

module Peddler
  class ErrorTest < Minitest::Test
    def test_invalid_input
      response = '{"errors":[{"code":"InvalidInput","message":"InvalidInput"}]}'
      error = Error.build(response)

      assert_kind_of(Errors::InvalidInput, error)
    end

    def test_not_found
      response = '{"errors":[{"code":"NotFound","message":"NotFound"}]}'
      error = Error.build(response)

      assert_kind_of(Errors::NotFound, error)
    end

    def test_quota_exceeded
      response = '{"errors":[{"code":"QuotaExceeded","message":"You exceeded your quota for the requested resource."}]}'
      error = Error.build(response)

      assert_kind_of(Errors::QuotaExceeded, error)
    end

    def test_unauthorized
      response = '{"errors":[{"code":"Unauthorized","message":"Access to requested resource is denied."}]}'
      error = Error.build(response)

      assert_kind_of(Errors::Unauthorized, error)
    end

    def test_unsupported_grant_type
      response = '{"error":"unsupported_grant_type","error_description":"The authorization grant type is not supported by the authorization server"}'
      error = Error.build(response)

      assert_kind_of(Errors::UnsupportedGrantType, error)
    end

    def test_invalid_grant
      response = '{"error_description":"The request has an invalid grant parameter : refresh_token. User may have unauthorized or didn' + 't grant the permission.","error":"invalid_grant"}'
      error = Error.build(response)

      assert_kind_of(Errors::InvalidGrant, error)
    end

    def test_invalid_request
      response = '{"error":"invalid_request","error_description":"The request is missing a required parameter : refresh_token"}'
      error = Error.build(response)

      assert_kind_of(Errors::InvalidRequest, error)
    end

    def test_access_denied
      response = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Error><Code>AccessDenied</Code><Message>Request has expired</Message><X-Amz-Expires>300</X-Amz-Expires><Expires>2025-06-03T12:26:02Z</Expires><ServerTime>2025-06-03T14:34:02Z</ServerTime><RequestId>123</RequestId><HostId>123</HostId></Error>"
      error = Error.build(response)

      begin
        require "nokogiri"

        assert_kind_of(Errors::AccessDenied, error)
      rescue LoadError
        assert_nil(error)
      end
    end

    def test_other_api_error
      response = '{"errors":[{"code":"OtherError","message":"OtherError"}]}'
      error = Error.build(response)

      assert_includes(Errors.constants, :OtherError)
      assert_kind_of(Errors::OtherError, error)
    end

    def test_other_token_error
      response = '{"error":"other_error","error_description":"OtherError"}'
      error = Error.build(response)

      assert_includes(Errors.constants, :OtherError)
      assert_kind_of(Errors::OtherError, error)
    end

    def test_normalized_screaming_snake_case
      response = '{"errors":[{"code":"NOT_FOUND","message":"Resource not found"}]}'
      error = Error.build(response)

      assert_kind_of(Errors::NotFound, error)
    end

    def test_invalid_class_name
      response = '{"errors":[{"code":"400","message":"Invalid Input"}]}'
      error = Error.build(response)

      assert_nil(error)
    end

    def test_xml_error_fallback
      # Test that invalid XML gracefully returns nil when nokogiri can't parse it
      response = "invalid xml content"
      error = Error.build(response)

      assert_nil(error)
    end
  end
end
