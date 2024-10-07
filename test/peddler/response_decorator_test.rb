# frozen_string_literal: true

require "helper"
require "peddler/response_decorator"

module Peddler
  class ResponseDecoratorTest < Minitest::Test
    def test_parses
      decorator = ResponseDecorator.decorate(response)

      assert_equal(payload, decorator.parse)
    end

    def test_to_h
      decorator = ResponseDecorator.decorate(response)

      assert_equal(payload, decorator.to_h)
    end

    def test_dig
      decorator = ResponseDecorator.decorate(response)

      assert(decorator.dig("foo"))
    end

    def test_parses_with_custom_parser
      decorator = ResponseDecorator.decorate(
        response, parser: ->(response) { JSON.parse(response, symbolize_names: true) }
      )

      assert_equal(payload_with_symbolized_keys, decorator.parse)
    end

    def test_to_h_with_custom_parser
      decorator = ResponseDecorator.decorate(
        response, parser: ->(response) { JSON.parse(response, symbolize_names: true) }
      )

      assert_equal(payload_with_symbolized_keys, decorator.to_h)
    end

    def test_dig_with_custom_parser
      decorator = ResponseDecorator.decorate(
        response, parser: ->(response) { JSON.parse(response, symbolize_names: true) }
      )

      assert(decorator.dig(:foo))
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
