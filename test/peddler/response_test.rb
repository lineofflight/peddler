# frozen_string_literal: true

require "helper"
require "peddler/response"

module Peddler
  class ResponseTest < Minitest::Test
    def test_parses
      wrapper = Response.wrap(response)

      assert_equal(payload, wrapper.parse)
    end

    def test_to_h
      wrapper = Response.wrap(response)

      assert_equal(payload, wrapper.to_h)
    end

    def test_dig
      wrapper = Response.wrap(response)

      assert(wrapper.dig("foo"))
    end

    def test_parses_with_custom_parser
      wrapper = Response.wrap(
        response, parser: ->(response) { JSON.parse(response, symbolize_names: true) }
      )

      assert_equal(payload_with_symbolized_keys, wrapper.parse)
    end

    def test_to_h_with_custom_parser
      wrapper = Response.wrap(
        response, parser: ->(response) { JSON.parse(response, symbolize_names: true) }
      )

      assert_equal(payload_with_symbolized_keys, wrapper.to_h)
    end

    def test_dig_with_custom_parser
      wrapper = Response.wrap(
        response, parser: ->(response) { JSON.parse(response, symbolize_names: true) }
      )

      assert(wrapper.dig(:foo))
    end

    def test_raises_error_on_client_error
      response = HTTP::Response.new(
        body: '{"errors":[{"code":"InvalidInput","message":"Invalid input"}]}',
        headers: { "Content-Type" => "application/json" },
        status: 400,
        version: "1.1",
        request: nil,
      )

      assert_raises(Peddler::Error) do
        Response.wrap(response)
      end
    end

    def test_raises_error_on_server_error
      response = HTTP::Response.new(
        body: '{"errors":[{"code":"InternalFailure","message":"We encountered an internal error. Please try again."}]}',
        headers: { "Content-Type" => "application/json" },
        status: 500,
        version: "1.1",
        request: nil,
      )

      assert_raises(Peddler::Error) do
        Response.wrap(response)
      end
    end

    def test_decorate_deprecation_still_works
      wrapper = Response.decorate(response)

      assert_equal(payload, wrapper.parse)
    end

    private

    def response
      HTTP::Response.new(
        body: JSON.dump(payload),
        headers: { "Content-Type" => "application/json" },
        status: nil,
        version: nil,
        request: nil,
      )
    end

    def payload
      { "foo" => "bar" }
    end

    def payload_with_symbolized_keys
      payload.transform_keys(&:to_sym)
    end
  end
end
