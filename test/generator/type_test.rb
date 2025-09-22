# frozen_string_literal: true

require "helper"
require "generator/type"

module Generator
  class TypeTest < Minitest::Test
    def setup
      @api_name = "test_api_v1"
      @specification = {
        "definitions" => {
          "SimpleType" => {
            "type" => "object",
            "properties" => {
              "name" => { "type" => "string" },
              "count" => { "type" => "integer" },
            },
          },
          "ComplexType" => {
            "type" => "object",
            "properties" => {
              "id" => { "type" => "string" },
              "items" => {
                "type" => "array",
                "items" => { "$ref" => "#/definitions/SimpleType" },
              },
            },
          },
          "Money" => {
            "type" => "object",
            "properties" => {
              "currencyCode" => { "type" => "string" },
              "amount" => { "type" => "string" },
            },
          },
          "TypeWithMoney" => {
            "type" => "object",
            "properties" => {
              "price" => { "$ref" => "#/definitions/Money" },
              "name" => { "type" => "string" },
            },
          },
          "SelfReferentialType" => {
            "type" => "object",
            "properties" => {
              "name" => { "type" => "string" },
              "parent" => { "$ref" => "#/definitions/SelfReferentialType" },
            },
          },
          "StringEnum" => {
            "type" => "string",
            "enum" => ["ACTIVE", "INACTIVE"],
          },
          "ArrayType" => {
            "type" => "array",
            "items" => { "$ref" => "#/definitions/SimpleType" },
          },
        },
      }
    end

    def test_simple_type_name
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_equal("SimpleType", type.name)
      assert_equal("SimpleType", type.class_name)
    end

    def test_simple_type_properties_count
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_equal(2, type.properties.size)
    end

    def test_simple_type_property_names
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_includes(type.properties.keys, "name")
      assert_includes(type.properties.keys, "count")
    end

    def test_ruby_type_for_string
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_equal("String", type.ruby_type_for({ "type" => "string" }))
    end

    def test_ruby_type_for_integer
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_equal("Integer", type.ruby_type_for({ "type" => "integer" }))
    end

    def test_ruby_type_for_number
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_equal("Float", type.ruby_type_for({ "type" => "number" }))
    end

    def test_ruby_type_for_boolean
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_equal(":boolean", type.ruby_type_for({ "type" => "boolean" }))
    end

    def test_ruby_type_for_object
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_equal("Hash", type.ruby_type_for({ "type" => "object" }))
    end

    def test_ruby_type_for_array_of_objects
      definition = @specification["definitions"]["ComplexType"]
      type = Type.new("ComplexType", definition, @api_name, @specification)

      array_prop = { "type" => "array", "items" => { "$ref" => "#/definitions/SimpleType" } }

      assert_equal("[SimpleType]", type.ruby_type_for(array_prop))
    end

    def test_ruby_type_for_array_of_objects_comment
      definition = @specification["definitions"]["ComplexType"]
      type = Type.new("ComplexType", definition, @api_name, @specification)

      array_prop = { "type" => "array", "items" => { "$ref" => "#/definitions/SimpleType" } }

      assert_equal("Array<SimpleType>", type.ruby_type_for(array_prop, for_comment: true))
    end

    def test_ruby_type_for_array_of_strings
      definition = @specification["definitions"]["ComplexType"]
      type = Type.new("ComplexType", definition, @api_name, @specification)

      string_array = { "type" => "array", "items" => { "type" => "string" } }

      assert_equal("[String]", type.ruby_type_for(string_array))
    end

    def test_ruby_type_for_array_of_strings_comment
      definition = @specification["definitions"]["ComplexType"]
      type = Type.new("ComplexType", definition, @api_name, @specification)

      string_array = { "type" => "array", "items" => { "type" => "string" } }

      assert_equal("Array<String>", type.ruby_type_for(string_array, for_comment: true))
    end

    def test_money_type_handling
      definition = @specification["definitions"]["TypeWithMoney"]
      type = Type.new("TypeWithMoney", definition, @api_name, @specification)

      assert_predicate(type, :needs_money?)
      money_prop = { "$ref" => "#/definitions/Money" }

      assert_equal("Types::Money", type.ruby_type_for(money_prop))
    end

    def test_self_referential_type
      definition = @specification["definitions"]["SelfReferentialType"]
      type = Type.new("SelfReferentialType", definition, @api_name, @specification)

      parent_prop = { "$ref" => "#/definitions/SelfReferentialType" }

      assert_equal(":self", type.ruby_type_for(parent_prop))
    end

    def test_type_dependencies
      definition = @specification["definitions"]["ComplexType"]
      type = Type.new("ComplexType", definition, @api_name, @specification)

      dependencies = type.type_dependencies

      assert_includes(dependencies, "SimpleType")
      refute_includes(dependencies, "Money") # Money is not a generated type
    end

    def test_type_dependencies_excludes_self
      definition = @specification["definitions"]["SelfReferentialType"]
      type = Type.new("SelfReferentialType", definition, @api_name, @specification)

      dependencies = type.type_dependencies

      refute_includes(dependencies, "SelfReferentialType")
    end

    def test_generated_object_types
      definition = @specification["definitions"]["ComplexType"]
      type = Type.new("ComplexType", definition, @api_name, @specification)

      assert(type.send(:generated_type?, "SimpleType"))
      assert(type.send(:generated_type?, "ComplexType"))
    end

    def test_money_not_generated
      definition = @specification["definitions"]["ComplexType"]
      type = Type.new("ComplexType", definition, @api_name, @specification)

      refute(type.send(:generated_type?, "Money"))
    end

    def test_non_object_types_not_generated
      definition = @specification["definitions"]["ComplexType"]
      type = Type.new("ComplexType", definition, @api_name, @specification)

      refute(type.send(:generated_type?, "StringEnum"))
      refute(type.send(:generated_type?, "ArrayType"))
    end

    def test_non_existent_type_not_generated
      definition = @specification["definitions"]["ComplexType"]
      type = Type.new("ComplexType", definition, @api_name, @specification)

      refute(type.send(:generated_type?, "NonExistentType"))
    end

    def test_library_name
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_equal("peddler/types/test_api_v1/simple_type", type.library_name)
    end

    def test_handle_ref_with_string_enum
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      string_enum_ref = { "$ref" => "#/definitions/StringEnum" }

      assert_equal("String", type.ruby_type_for(string_enum_ref))
    end

    def test_handle_ref_with_array_type
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      array_type_ref = { "$ref" => "#/definitions/ArrayType" }

      assert_equal("[SimpleType]", type.ruby_type_for(array_type_ref))
    end

    def test_handle_ref_with_array_type_comment
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      array_type_ref = { "$ref" => "#/definitions/ArrayType" }

      assert_equal("Array<SimpleType>", type.ruby_type_for(array_type_ref, for_comment: true))
    end

    def test_format_property_comment_with_description
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      prop_with_desc = { "type" => "string", "description" => "The name of the item" }
      comment = type.send(:format_property_comment, prop_with_desc)

      assert_match(/@return \[String\] The name of the item/, comment)
    end

    def test_format_property_comment_without_description
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      prop_without_desc = { "type" => "integer" }
      comment = type.send(:format_property_comment, prop_without_desc)

      assert_equal("        # @return [Integer]", comment)
    end

    def test_required_properties
      definition = {
        "type" => "object",
        "required" => ["id", "name"],
        "properties" => {
          "id" => { "type" => "string" },
          "name" => { "type" => "string" },
          "optional" => { "type" => "string" },
        },
      }
      type = Type.new("RequiredTest", definition, @api_name, @specification)

      assert_equal(["id", "name"], type.required_properties)
    end

    def test_no_required_properties
      definition = @specification["definitions"]["SimpleType"]
      type = Type.new("SimpleType", definition, @api_name, @specification)

      assert_empty(type.required_properties)
    end
  end
end
