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

    def test_other_error
      refute_includes(Errors.constants, :OtherError)

      response = '{"errors":[{"code":"OtherError","message":"OtherError"}]}'
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
  end
end
