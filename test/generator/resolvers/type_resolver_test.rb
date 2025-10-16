# frozen_string_literal: true

require "helper"
require "generator/resolvers/type_resolver"

module Generator
  class TypeResolverTest < Minitest::Test
    def test_array_with_ref_to_generated_type
      specification = {
        "definitions" => {
          "Offer" => {
            "type" => "object",
            "properties" => {
              "sellerId" => { "type" => "string" },
            },
          },
        },
      }

      resolver = TypeResolver.new("Notification", specification)
      prop_def = {
        "type" => "array",
        "items" => {
          "$ref" => "#/definitions/Offer",
        },
      }

      assert_equal("[Offer]", resolver.resolve(prop_def))
      assert_equal("Array<Offer>", resolver.resolve(prop_def, for_comment: true))
    end

    def test_array_with_tuple_style_ref
      specification = {
        "definitions" => {
          "Item" => {
            "type" => "object",
            "properties" => {
              "name" => { "type" => "string" },
            },
          },
        },
      }

      resolver = TypeResolver.new("Order", specification)
      # Amazon's non-standard tuple-style array items
      prop_def = {
        "type" => "array",
        "items" => [
          {
            "$ref" => "#/definitions/Item",
          },
        ],
      }

      # TypeResolver should handle tuple-style items
      assert_equal("[Item]", resolver.resolve(prop_def))
      assert_equal("Array<Item>", resolver.resolve(prop_def, for_comment: true))
    end

    def test_generated_type_with_additional_properties_true
      specification = {
        "definitions" => {
          "Product" => {
            "type" => "object",
            "additionalProperties" => true,
            "properties" => {
              "id" => { "type" => "string" },
              "name" => { "type" => "string" },
            },
          },
        },
      }

      resolver = TypeResolver.new("Catalog", specification)

      # Should be recognized as generated type even with additionalProperties: true
      assert(resolver.generated_type?("Product"))
    end

    def test_not_generated_type_with_only_additional_properties
      specification = {
        "definitions" => {
          "Metadata" => {
            "type" => "object",
            "additionalProperties" => { "type" => "string" },
          },
        },
      }

      resolver = TypeResolver.new("Response", specification)

      # Should NOT be recognized as generated type (it's a Hash)
      refute(resolver.generated_type?("Metadata"))
    end

    def test_array_with_primitive_type
      resolver = TypeResolver.new("List", nil)
      prop_def = {
        "type" => "array",
        "items" => {
          "type" => "string",
        },
      }

      assert_equal("[String]", resolver.resolve(prop_def))
      assert_equal("Array<String>", resolver.resolve(prop_def, for_comment: true))
    end

    def test_generated_type_check_for_money
      specification = {
        "definitions" => {
          "Money" => {
            "type" => "object",
            "properties" => {
              "amount" => { "type" => "number" },
              "currencyCode" => { "type" => "string" },
            },
          },
        },
      }

      resolver = TypeResolver.new("Price", specification)

      # Money types should not be treated as generated types
      refute(resolver.generated_type?("Peddler::Money"))
    end

    def test_ref_to_money_type
      specification = {
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

      resolver = TypeResolver.new("Price", specification)
      prop_def = {
        "$ref" => "#/definitions/MoneyType",
      }

      # Should resolve to Money, not MoneyType
      assert_equal("Money", resolver.resolve(prop_def))
    end
  end
end
