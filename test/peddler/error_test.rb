# frozen_string_literal: true

require "helper"

# An error is asserted through its readers together.
# rubocop:disable Minitest/MultipleAssertions
module Peddler
  class ErrorTest < Minitest::Test
    def test_readers
      error = build(429, code: "QuotaExceeded", request_id: "abc-123", message: "You exceeded your quota.")

      assert_equal(429, error.status)
      assert_equal("QuotaExceeded", error.code)
      assert_equal("abc-123", error.request_id)
      assert_instance_of(Response, error.response)
      assert_equal("You exceeded your quota.", error.message)
    end

    def test_message_falls_back_when_amazon_sends_none
      assert_equal("request failed with status 503", build(503).message)
      assert_equal("request failed with status 503", build(503, code: "InternalFailure").message)
    end

    def test_code_and_request_id_are_nil_when_amazon_sends_none
      error = build(500)

      assert_nil(error.code)
      assert_nil(error.request_id)
    end

    def test_constructs_without_a_response
      error = Error.new("boom")

      assert_equal("boom", error.message)
      assert_nil(error.response)
      assert_nil(error.status)
      assert_nil(error.code)
      assert_nil(error.request_id)
      assert_equal("Peddler::Error", Error.new.message)
    end

    def test_constructs_with_a_response_code_and_request_id
      response = Response.new(404, [], "{}", ["NotFound", "abc", nil])
      error = Error.new("gone", response, code: "NotFound", request_id: "abc")

      assert_same(response, error.response)
      assert_equal([404, "NotFound", "abc"], [error.status, error.code, error.request_id])
    end

    def test_deconstruct_keys_exposes_status_and_code_only
      error = build(429, code: "QuotaExceeded", message: "You exceeded your quota.")

      assert_equal({ status: 429, code: "QuotaExceeded" }, error.deconstruct_keys(nil))
      assert_equal({ status: 429 }, error.deconstruct_keys([:status]))
      assert_empty(error.deconstruct_keys([:response, :request_id, :message]))
      assert_equal({ status: nil, code: nil }, Error.new("boom").deconstruct_keys(nil))
    end

    def test_pattern_matches_status_code_and_range
      assert_pattern { build(429) => { status: 429 } }
      assert_pattern { build(400, code: "QuotaExceeded", message: "m") => { code: "QuotaExceeded" } }
      assert_pattern { build(503) => { status: 500.. } }
      refute_pattern { build(404) => { status: 500.. } }
    end

    # Every error class of the gem, its superclass and the methods it adds. Where a class is defined must not change
    # any of them.
    def test_error_hierarchy
      errors = Peddler.constants.sort.filter_map do |name|
        value = Peddler.const_get(name)
        [name, value.superclass, value.instance_methods(false).sort] if value.is_a?(Class) && value < Exception
      end
      expected = [
        [:AuthenticationError, StandardError, [:code, :status]],
        [:DocumentError, StandardError, [:document_id, :with_document_id]],
        [:DocumentTimeoutError, DocumentError, []],
        [:Error, StandardError, [:code, :deconstruct_keys, :request_id, :response, :status]],
        [:ForkError, StandardError, []],
        [:PaginationError, StandardError, [:reason]],
        [:TimeoutError, TransportError, []],
        [:TransportError, StandardError, []],
        [:WorkflowError, StandardError, []],
        [:WorkflowTimeoutError, WorkflowError, []],
      ]

      assert_equal(expected, errors)
      assert_equal([:message, :status, :code], AuthenticationError.instance_method(:initialize).parameters.map(&:last))
    end

    private

    def build(status, code: nil, request_id: nil, message: nil)
      assert_raises(Error) { Response.new(status, [], "", [code, request_id, message]).raise_for_status! }
    end
  end

  # Replays error responses recorded from Amazon. Every surface raises the same class.
  class RecordedErrorTest < Minitest::Test
    include FeatureHelpers

    NOT_FOUND = "Peddler/Errors/NotFoundTest/test_not_found"
    QUOTA_EXCEEDED = "Peddler/Errors/QuotaExceededTest/test_quota_exceeded"

    def cassette
      name.match?(/quota|retries/) ? QUOTA_EXCEEDED : NOT_FOUND
    end

    def test_operation_raises_not_found
      error = assert_raises(Error) { client.reports_2021_06_30.get_report(report_id: "1234567") }

      assert_equal(404, error.status)
      assert_equal("NotFound", error.code)
      assert_equal(404, error.response.status)
      assert_match(/could not be found/, error.message)
      assert(error.request_id)
      assert_equal("NotFound", error.response.dig("errors", 0, "code"))
    end

    def test_operation_raises_quota_exceeded
      error = assert_raises(Error) do
        client.product_pricing_v0.get_pricing(marketplace_id: "A1F83G8C2ARO7P", item_type: "Asin", asins: ["188864544X"])
      end

      assert_equal(429, error.status)
      assert_equal("QuotaExceeded", error.code)
      assert_equal("You exceeded your quota for the requested resource.", error.message)
    end

    def test_request_raises
      error = assert_raises(Error) { client.request("GET", "/reports/2021-06-30/reports/1234567") }

      assert_equal([404, "NotFound"], [error.status, error.code])
    end

    def test_lifecycle_metadata_lookup_raises
      error = assert_raises(Error) { client.wait_for_report("1234567", interval: 0.01, timeout: 2) }

      assert_equal([404, "NotFound"], [error.status, error.code])
      refute_kind_of(WorkflowError, error)
    end

    def test_retries_exhausted_raise_the_last_response
      retrying = Client.new(base_url: @replay.url, access_token: "FILTERED", retries: 1, retry_delay: 0.01)
      error = assert_raises(Error) do
        retrying.product_pricing_v0.get_pricing(marketplace_id: "A1F83G8C2ARO7P", item_type: "Asin", asins: ["188864544X"])
      end

      assert_equal([429, "QuotaExceeded"], [error.status, error.code])
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
