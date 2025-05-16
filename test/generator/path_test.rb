# frozen_string_literal: true

require "minitest/autorun"
require "generator/path"

module Generator
  class PathTest < Minitest::Test
    def test_path_interpolation
      # Basic path interpolation
      path = Path.new("/test/{paramName}", {})

      assert_equal("/test/\#{URI.encode_uri_component(param_name)}", path.path)

      # Multiple parameters
      path = Path.new("/test/{param1}/{param2}", {})

      assert_equal("/test/\#{URI.encode_uri_component(param1)}/\#{URI.encode_uri_component(param2)}", path.path)
    end

    def test_uri_encoding_in_generated_code
      template = "/listings/2021-08-01/items/{sellerId}/{sku}"
      path = Path.new(template, {})

      # Verify the path pattern contains the expected URI encoding
      assert_match(/URI\.encode_uri_component/, path.path)
    end

    def test_uri_interpolation_with_special_characters
      # Use lambdas instead of nested method definitions
      test_interpolation = lambda do |seller_id, sku|
        "/listings/2021-08-01/items/#{URI.encode_uri_component(seller_id)}/#{URI.encode_uri_component(sku)}"
      end

      # Test with normal values
      assert_equal(
        "/listings/2021-08-01/items/seller123/normalSKU",
        test_interpolation.call("seller123", "normalSKU"),
      )

      # Test with spaces
      assert_equal(
        "/listings/2021-08-01/items/seller%20123/SKU%20with%20spaces",
        test_interpolation.call("seller 123", "SKU with spaces"),
      )

      # Test with special characters that would cause URI::InvalidComponentError
      assert_equal(
        "/listings/2021-08-01/items/seller%3F123/SKU%26special%23chars",
        test_interpolation.call("seller?123", "SKU&special#chars"),
      )
    end

    def test_uri_encoding_prevents_invalid_component_error
      # Create a simple lambda that simulates what would happen in the generated code
      test_uri_safety = lambda do |param|
        "/test/#{URI.encode_uri_component(param)}"
      end

      # This would normally raise URI::InvalidComponentError without proper encoding
      result = test_uri_safety.call("value with ? & # chars")

      assert_equal("/test/value%20with%20%3F%20%26%20%23%20chars", result)
    end
  end
end
