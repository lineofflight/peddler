# frozen_string_literal: true

require "helper"
require "generator/support/schema_helpers"
require "generator/resolvers/type_resolver"
require "generator/parsers/json_schema_extractor"

module Generator
  class SchemaHelpersTest < Minitest::Test
    class TestClass
      include SchemaHelpers

      attr_reader :schema, :name, :api_name_for_type_resolver

      def initialize(schema, name, api_name)
        @schema = schema
        @name = name
        @api_name_for_type_resolver = api_name
      end

      # Expose properties for testing (some generators have this method)
      def properties
        schema["properties"] || {}
      end
    end

    def test_attribute_name_for_regular_property
      obj = TestClass.new({}, "Test", "test_api")

      assert_equal("seller_id", obj.attribute_name_for("sellerId", {}))
    end

    def test_attribute_name_for_boolean_strips_is_prefix
      obj = TestClass.new({}, "Test", "test_api")
      prop_def = { "type" => "boolean" }

      assert_equal("prime", obj.attribute_name_for("isPrime", prop_def))
      assert_equal("business_order", obj.attribute_name_for("isBusinessOrder", prop_def))
    end

    def test_attribute_name_for_boolean_type_bool_variant
      obj = TestClass.new({}, "Test", "test_api")
      prop_def = { "type" => "bool" }

      assert_equal("active", obj.attribute_name_for("isActive", prop_def))
    end

    def test_attribute_name_for_non_boolean_keeps_is_prefix
      obj = TestClass.new({}, "Test", "test_api")
      prop_def = { "type" => "string" }

      # Should NOT strip is_ for non-boolean types
      assert_equal("is_sku", obj.attribute_name_for("isSKU", prop_def))
    end

    def test_generic_placeholder_returns_true_for_amazon_placeholder
      obj = TestClass.new({}, "Test", "test_api")

      assert(obj.generic_placeholder?("An explanation about the purpose of this instance."))
      assert(obj.generic_placeholder?("An explanation about the purpose of this instance"))
      assert(obj.generic_placeholder?("an explanation about the purpose of this instance."))
    end

    def test_generic_placeholder_returns_false_for_real_description
      obj = TestClass.new({}, "Test", "test_api")

      refute(obj.generic_placeholder?("The order ID for this order"))
      refute(obj.generic_placeholder?("An explanation about orders"))
      refute(obj.generic_placeholder?(nil))
    end

    def test_needs_money_with_extracted_types_containing_money
      obj = TestClass.new({}, "Test", "test_api")
      extracted_types = {
        "Order" => {
          "properties" => {
            "total" => { "$ref" => "#/definitions/Money" },
          },
        },
      }

      assert(obj.needs_money?(extracted_types))
    end

    def test_needs_money_with_extracted_types_containing_money_in_array
      obj = TestClass.new({}, "Test", "test_api")
      extracted_types = {
        "Order" => {
          "properties" => {
            "charges" => {
              "type" => "array",
              "items" => { "$ref" => "#/definitions/Money" },
            },
          },
        },
      }

      assert(obj.needs_money?(extracted_types))
    end

    def test_needs_money_with_extracted_types_without_money
      obj = TestClass.new({}, "Test", "test_api")
      extracted_types = {
        "Order" => {
          "properties" => {
            "id" => { "type" => "string" },
          },
        },
      }

      refute(obj.needs_money?(extracted_types))
    end

    def test_needs_money_with_properties_method
      schema = {
        "properties" => {
          "orderTotal" => { "$ref" => "#/definitions/MoneyType" },
        },
        "definitions" => {
          "MoneyType" => {
            "type" => "object",
            "properties" => {
              "amount" => { "type" => "number" },
              "currencyCode" => { "type" => "string" },
            },
          },
        },
      }
      obj = TestClass.new(schema, "Test", "test_api")

      # Should check properties when no extracted_types provided
      assert_predicate(obj, :needs_money?)
    end

    def test_nested_type_files_returns_sorted_underscored_names
      schema = {
        "properties" => {
          "item" => {
            "type" => "object",
            "properties" => {
              "name" => { "type" => "string" },
            },
          },
          "metadata" => {
            "type" => "object",
            "properties" => {
              "createdAt" => { "type" => "string" },
            },
          },
        },
      }
      obj = TestClass.new(schema, "Order", "test_api")

      files = obj.nested_type_files

      assert_instance_of(Array, files)
      assert(files.all?(String))
      # Should be sorted
      assert_equal(files, files.sort)
    end

    def test_format_property_comment_with_description
      schema = {}
      obj = TestClass.new(schema, "Test", "test_api")

      prop_def = {
        "type" => "string",
        "description" => "The unique order identifier",
      }

      comment = obj.format_property_comment(prop_def)

      assert_includes(comment, "@return [String]")
      assert_includes(comment, "The unique order identifier")
    end

    def test_format_property_comment_without_description
      schema = {}
      obj = TestClass.new(schema, "Test", "test_api")

      prop_def = { "type" => "integer" }

      comment = obj.format_property_comment(prop_def)

      assert_includes(comment, "@return [Integer]")
      refute_includes(comment, "An explanation")
    end

    def test_format_property_comment_with_generic_placeholder
      schema = {}
      obj = TestClass.new(schema, "Test", "test_api")

      prop_def = {
        "type" => "string",
        "description" => "An explanation about the purpose of this instance.",
      }

      comment = obj.format_property_comment(prop_def)
      # Should not include the generic placeholder
      refute_includes(comment, "An explanation about the purpose")
      assert_includes(comment, "@return [String]")
    end

    def test_ruby_type_for_delegates_to_type_resolver
      schema = {
        "properties" => {
          "id" => { "type" => "string" },
        },
      }
      obj = TestClass.new(schema, "Test", "test_api")

      type = obj.ruby_type_for({ "type" => "string" })

      assert_equal("String", type)
    end

    def test_ruby_type_for_with_for_comment_option
      schema = {
        "properties" => {
          "items" => {
            "type" => "array",
            "items" => { "type" => "string" },
          },
        },
      }
      obj = TestClass.new(schema, "Test", "test_api")

      type = obj.ruby_type_for({ "type" => "array", "items" => { "type" => "string" } }, for_comment: true)

      assert_equal("Array<String>", type)
    end

    def test_type_resolver_is_memoized
      schema = {
        "properties" => {
          "id" => { "type" => "string" },
        },
      }
      obj = TestClass.new(schema, "Test", "test_api")

      resolver1 = obj.type_resolver
      resolver2 = obj.type_resolver

      assert_same(resolver1, resolver2)
    end

    def test_api_name_for_type_resolver_not_implemented_error
      # Create a minimal class that includes SchemaHelpers but doesn't implement the hook
      minimal_class = Class.new do
        include SchemaHelpers

        attr_reader :schema

        def initialize(schema)
          @schema = schema
        end

        def name
          "Test"
        end
      end

      obj = minimal_class.new({})

      error = assert_raises(NotImplementedError) do
        obj.send(:api_name_for_type_resolver)
      end

      assert_includes(error.message, "Subclass must implement api_name_for_type_resolver")
    end
  end
end
