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

    def test_decorate_deprecation_still_works
      wrapper = nil
      assert_output(nil, /Response\.decorate is deprecated/) do
        wrapper = Response.decorate(response)
      end

      assert_equal(payload, wrapper.parse)
    end

    def test_deprecation_removal_reminder
      if Gem.loaded_specs["peddler"].version.segments.first >= 5
        flunk("Response.decorate should have been removed in v5.0. Please delete it now.")
      end
    end

    def test_server_error_behavior_removal_reminder
      if Gem.loaded_specs["peddler"].version.segments.first >= 5
        flunk(<<~MSG)
          Server error handling backward compatibility should be removed in v5.0.
          Please:
          1. Remove lib/peddler/config.rb
          2. Remove test/peddler/config_test.rb
          3. Remove the require from lib/peddler/response.rb
          4. Remove the require from the generator template
          5. Remove the deprecation warning method
          6. Make all errors (4xx and 5xx) raise exceptions unconditionally
          7. Update this test to verify all errors raise
          8. Update README to remove the Error Handling section about configuration
        MSG
      end
    end

    def test_server_errors_return_response_by_default
      server_error = HTTP::Response.new(
        body: "Internal Server Error",
        headers: {},
        status: 500,
        version: nil,
        request: nil,
      )

      # Should emit deprecation warning
      wrapper = nil
      assert_output(nil, /\[DEPRECATION\]/) do
        wrapper = Response.wrap(server_error)
      end

      # Should return wrapped response, not raise
      assert_instance_of(Response, wrapper)
      assert_equal(500, wrapper.status)
    end

    def test_server_errors_raise_when_configured
      Peddler.raise_on_server_errors = true

      server_error = HTTP::Response.new(
        body: JSON.dump({ "errors" => [{ "code" => "InternalError", "message" => "Server error" }] }),
        headers: { "Content-Type" => "application/json" },
        status: 500,
        version: nil,
        request: nil,
      )

      # Should raise error
      assert_raises(Peddler::Error) do
        Response.wrap(server_error)
      end
    ensure
      # Reset configuration
      Peddler.instance_variable_set(:@raise_on_server_errors, nil)
    end

    def test_client_errors_always_raise
      client_error = HTTP::Response.new(
        body: JSON.dump({ "errors" => [{ "code" => "NotFound", "message" => "Not found" }] }),
        headers: { "Content-Type" => "application/json" },
        status: 404,
        version: nil,
        request: nil,
      )

      # Should always raise regardless of configuration
      assert_raises(Peddler::Errors::NotFound) do
        Response.wrap(client_error)
      end
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
