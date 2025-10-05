# frozen_string_literal: true

require "helper"
require "peddler/response"

module Peddler
  class ResponseTest < Minitest::Test
    def test_parse
      wrapper = Response.new(response)

      assert_equal(payload, wrapper.parse)
    end

    def test_to_h
      wrapper = Response.new(response)

      assert_equal(payload, wrapper.to_h)
    end

    def test_dig
      wrapper = Response.new(response)

      assert(wrapper.dig("foo"))
    end

    def test_wrap_returns_response_for_success
      wrapper = Response.wrap(response)

      assert_equal(payload, wrapper.parse)
    end

    def test_wrap_raises_for_client_error
      error_response = HTTP::Response.new(
        status: 400,
        version: "1.1",
        headers: { "Content-Type" => "application/json" },
        body: '{"errors": [{"code": "InvalidInput", "message": "Bad request"}]}',
        request: nil,
      )

      assert_raises(Peddler::Errors::InvalidInput) do
        Response.wrap(error_response)
      end
    end

    def test_wrap_with_parser
      wrapper = Response.wrap(response, parser: custom_parser)

      assert_equal(payload, wrapper.parse)
    end

    def test_parsable_with_parser
      wrapper = Response.new(response, parser: custom_parser)

      assert_predicate(wrapper, :parsable?)
    end

    def test_parsable_without_parser
      wrapper = Response.new(response)

      refute_predicate(wrapper, :parsable?)
    end

    def test_parse_with_custom_parser
      wrapper = Response.new(response, parser: custom_parser)

      assert_equal(payload, wrapper.parse)
    end

    def test_parse_with_structure_type
      # Create a Structure type similar to our generated types
      require "structure"
      test_type = Structure.new do
        attribute(:marketplace_id, String)
        attribute(:seller_id, String)
        attribute(:feed_id, String)
      end

      # Create response with string keys (as comes from JSON)
      json_payload = {
        "marketplace_id" => "ATVPDKIKX0DER",
        "seller_id" => "A123456789",
        "feed_id" => "50029018011",
      }

      http_response = HTTP::Response.new(
        body: JSON.dump(json_payload),
        headers: { "Content-Type" => "application/json" },
        status: nil,
        version: nil,
        request: nil,
      )

      wrapper = Response.new(http_response, parser: -> { test_type })
      parsed = wrapper.parse

      # Test that values are correctly parsed
      assert_equal("ATVPDKIKX0DER", parsed.marketplace_id, "marketplace_id should be parsed correctly")
      assert_equal("A123456789", parsed.seller_id, "seller_id should be parsed correctly")
      assert_equal("50029018011", parsed.feed_id, "feed_id should be parsed correctly")
    end

    def test_parse_with_camelcase_to_snake_case_mapping
      # Test that Structure correctly maps camelCase JSON keys to snake_case attributes
      require "structure"

      feed_type = Structure.new do
        attribute(:marketplace_id, String, from: "marketplaceId")
        attribute(:seller_id, String, from: "sellerId")
        attribute(:feed_id, String, from: "feedId")
      end

      # JSON response with camelCase keys
      json_payload = {
        "marketplaceId" => "ATVPDKIKX0DER",
        "sellerId" => "A123456789",
        "feedId" => "50029018011",
      }

      http_response = HTTP::Response.new(
        body: JSON.dump(json_payload),
        headers: { "Content-Type" => "application/json" },
        status: nil,
        version: nil,
        request: nil,
      )

      wrapper = Response.new(http_response, parser: -> { feed_type })
      parsed = wrapper.parse

      # Verify we can access values using snake_case attribute names
      assert_equal("ATVPDKIKX0DER", parsed.marketplace_id, "marketplace_id should be accessible with snake_case")
      assert_equal("A123456789", parsed.seller_id, "seller_id should be accessible with snake_case")
      assert_equal("50029018011", parsed.feed_id, "feed_id should be accessible with snake_case")
    end

    def test_parse_with_nested_payload_structure
      # Test parsing when data is nested under "payload" key
      require "structure"

      # Create nested structure types
      feed_type = Structure.new do
        attribute(:marketplace_id, String)
        attribute(:seller_id, String)
        attribute(:feed_id, String)
      end

      # Simulate what happens with a real API response that has a payload wrapper
      json_response = {
        "payload" => {
          "marketplace_id" => "ATVPDKIKX0DER",
          "seller_id" => "A123456789",
          "feed_id" => "50029018011",
        },
      }

      http_response = HTTP::Response.new(
        body: JSON.dump(json_response),
        headers: { "Content-Type" => "application/json" },
        status: nil,
        version: nil,
        request: nil,
      )

      # This simulates what happens when we extract the payload first
      wrapper = Response.new(http_response)
      payload_data = wrapper.to_h["payload"]

      # Now parse the payload data with the Structure type
      parsed = feed_type.parse(payload_data)

      # Verify the values are correctly parsed
      assert_equal("ATVPDKIKX0DER", parsed.marketplace_id, "marketplace_id should be parsed from nested payload")
      assert_equal("A123456789", parsed.seller_id, "seller_id should be parsed from nested payload")
      assert_equal("50029018011", parsed.feed_id, "feed_id should be parsed from nested payload")
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

    def custom_parser
      test_payload = payload
      parser_class = Class.new do
        define_singleton_method :parse do |_payload|
          test_payload
        end
      end
      lambda { parser_class }
    end

    def payload
      { "foo" => "bar" }
    end
  end
end
