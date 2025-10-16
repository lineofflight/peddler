# frozen_string_literal: true

require "helper"
require "generator/builders/type"

module Generator
  class TypeTest < Minitest::Test
    API_NAME = "test_api"

    def test_simple_type_name
      definition = {
        "type" => "object",
        "properties" => {
          "name" => { "type" => "string" },
        },
      }
      specification = { "definitions" => {} }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      assert_equal("SimpleType", type.name)
      assert_equal("SimpleType", type.class_name)
    end

    def test_simple_type_properties_count
      definition = {
        "type" => "object",
        "properties" => {
          "name" => { "type" => "string" },
          "count" => { "type" => "integer" },
        },
      }
      specification = { "definitions" => {} }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      assert_equal(2, type.properties.size)
    end

    def test_simple_type_property_names
      definition = {
        "type" => "object",
        "properties" => {
          "name" => { "type" => "string" },
          "count" => { "type" => "integer" },
        },
      }
      specification = { "definitions" => {} }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      assert_includes(type.properties.keys, "name")
      assert_includes(type.properties.keys, "count")
    end

    def test_ruby_type_for_primitive_types
      definition = { "type" => "object", "properties" => {} }
      specification = { "definitions" => {} }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      test_cases = {
        "string" => "String",
        "integer" => "Integer",
        "number" => "Float",
        "boolean" => ":boolean",
        "object" => "Hash",
      }

      test_cases.each do |json_type, expected_ruby_type|
        assert_equal(
          expected_ruby_type,
          type.ruby_type_for({ "type" => json_type }),
          "Expected #{json_type} to map to #{expected_ruby_type}",
        )
      end
    end

    def test_ruby_type_for_array_of_objects
      definition = { "type" => "object", "properties" => {} }
      specification = {
        "definitions" => {
          "SimpleType" => { "type" => "object", "properties" => {} },
        },
      }
      type = Type.new("ComplexType", definition, API_NAME, specification)

      array_prop = { "type" => "array", "items" => { "$ref" => "#/definitions/SimpleType" } }

      assert_equal("[SimpleType]", type.ruby_type_for(array_prop))
    end

    def test_ruby_type_for_array_of_objects_comment
      definition = { "type" => "object", "properties" => {} }
      specification = {
        "definitions" => {
          "SimpleType" => { "type" => "object", "properties" => {} },
        },
      }
      type = Type.new("ComplexType", definition, API_NAME, specification)

      array_prop = { "type" => "array", "items" => { "$ref" => "#/definitions/SimpleType" } }

      assert_equal("Array<SimpleType>", type.ruby_type_for(array_prop, for_comment: true))
    end

    def test_ruby_type_for_array_of_strings
      definition = { "type" => "object", "properties" => {} }
      specification = { "definitions" => {} }
      type = Type.new("ComplexType", definition, API_NAME, specification)

      string_array = { "type" => "array", "items" => { "type" => "string" } }

      assert_equal("[String]", type.ruby_type_for(string_array))
    end

    def test_ruby_type_for_array_of_strings_comment
      definition = { "type" => "object", "properties" => {} }
      specification = { "definitions" => {} }
      type = Type.new("ComplexType", definition, API_NAME, specification)

      string_array = { "type" => "array", "items" => { "type" => "string" } }

      assert_equal("Array<String>", type.ruby_type_for(string_array, for_comment: true))
    end

    def test_money_type_handling
      definition = {
        "type" => "object",
        "properties" => {
          "price" => { "$ref" => "#/definitions/Money" },
        },
      }
      specification = {
        "definitions" => {
          "Money" => {
            "type" => "object",
            "properties" => {
              "currencyCode" => { "type" => "string" },
              "amount" => { "type" => "string" },
            },
          },
        },
      }
      type = Type.new("TypeWithMoney", definition, API_NAME, specification)

      assert_predicate(type, :needs_money?)
      money_prop = { "$ref" => "#/definitions/Money" }

      assert_equal("Money", type.ruby_type_for(money_prop))
    end

    def test_self_referential_type
      definition = {
        "type" => "object",
        "properties" => {
          "name" => { "type" => "string" },
          "parent" => { "$ref" => "#/definitions/SelfReferentialType" },
        },
      }
      specification = {
        "definitions" => {
          "SelfReferentialType" => definition,
        },
      }
      type = Type.new("SelfReferentialType", definition, API_NAME, specification)

      parent_prop = { "$ref" => "#/definitions/SelfReferentialType" }

      assert_equal(":self", type.ruby_type_for(parent_prop))
    end

    def test_array_with_self_reference
      definition = {
        "type" => "object",
        "properties" => {
          "name" => { "type" => "string" },
          "children" => {
            "type" => "array",
            "items" => { "$ref" => "#/definitions/TreeNode" },
          },
        },
      }
      specification = {
        "definitions" => {
          "TreeNode" => definition,
        },
      }
      type = Type.new("TreeNode", definition, API_NAME, specification)

      children_prop = {
        "type" => "array",
        "items" => { "$ref" => "#/definitions/TreeNode" },
      }

      assert_equal("[:self]", type.ruby_type_for(children_prop))
    end

    def test_array_with_self_reference_comment
      definition = {
        "type" => "object",
        "properties" => {
          "name" => { "type" => "string" },
          "children" => {
            "type" => "array",
            "items" => { "$ref" => "#/definitions/TreeNode" },
          },
        },
      }
      specification = {
        "definitions" => {
          "TreeNode" => definition,
        },
      }
      type = Type.new("TreeNode", definition, API_NAME, specification)

      children_prop = {
        "type" => "array",
        "items" => { "$ref" => "#/definitions/TreeNode" },
      }

      assert_equal("Array<self>", type.ruby_type_for(children_prop, for_comment: true))
    end

    def test_type_dependencies
      definition = {
        "type" => "object",
        "properties" => {
          "items" => {
            "type" => "array",
            "items" => { "$ref" => "#/definitions/SimpleType" },
          },
          "price" => { "$ref" => "#/definitions/Money" },
        },
      }
      specification = {
        "definitions" => {
          "SimpleType" => { "type" => "object", "properties" => {} },
          "Money" => {
            "type" => "object",
            "properties" => {
              "currencyCode" => { "type" => "string" },
              "amount" => { "type" => "string" },
            },
          },
        },
      }
      type = Type.new("ComplexType", definition, API_NAME, specification)

      dependencies = type.type_dependencies

      assert_includes(dependencies, "SimpleType")
      refute_includes(dependencies, "Money") # Money is not a generated type
    end

    def test_type_dependencies_excludes_self
      definition = {
        "type" => "object",
        "properties" => {
          "parent" => { "$ref" => "#/definitions/SelfReferentialType" },
        },
      }
      specification = {
        "definitions" => {
          "SelfReferentialType" => definition,
        },
      }
      type = Type.new("SelfReferentialType", definition, API_NAME, specification)

      dependencies = type.type_dependencies

      refute_includes(dependencies, "SelfReferentialType")
    end

    def test_generated_object_types
      definition = { "type" => "object", "properties" => {} }
      specification = {
        "definitions" => {
          "SimpleType" => { "type" => "object", "properties" => {} },
          "ComplexType" => { "type" => "object", "properties" => {} },
        },
      }
      type = Type.new("ComplexType", definition, API_NAME, specification)

      assert(type.send(:generated_type?, "SimpleType"))
      assert(type.send(:generated_type?, "ComplexType"))
    end

    def test_money_not_generated
      definition = { "type" => "object", "properties" => {} }
      specification = {
        "definitions" => {
          "Money" => {
            "type" => "object",
            "properties" => {
              "currencyCode" => { "type" => "string" },
              "amount" => { "type" => "string" },
            },
          },
        },
      }
      type = Type.new("ComplexType", definition, API_NAME, specification)

      refute(type.send(:generated_type?, "Money"))
    end

    def test_non_object_types_not_generated
      definition = { "type" => "object", "properties" => {} }
      specification = {
        "definitions" => {
          "StringEnum" => {
            "type" => "string",
            "enum" => ["ACTIVE", "INACTIVE"],
          },
          "ArrayType" => {
            "type" => "array",
            "items" => { "type" => "string" },
          },
        },
      }
      type = Type.new("ComplexType", definition, API_NAME, specification)

      refute(type.send(:generated_type?, "StringEnum"))
      refute(type.send(:generated_type?, "ArrayType"))
    end

    def test_non_existent_type_not_generated
      definition = { "type" => "object", "properties" => {} }
      specification = { "definitions" => {} }
      type = Type.new("ComplexType", definition, API_NAME, specification)

      refute(type.send(:generated_type?, "NonExistentType"))
    end

    def test_library_name
      definition = { "type" => "object", "properties" => {} }
      specification = { "definitions" => {} }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      assert_equal("peddler/apis/test_api/simple_type", type.library_name)
    end

    def test_handle_ref_with_string_enum
      definition = { "type" => "object", "properties" => {} }
      specification = {
        "definitions" => {
          "StringEnum" => {
            "type" => "string",
            "enum" => ["ACTIVE", "INACTIVE"],
          },
        },
      }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      string_enum_ref = { "$ref" => "#/definitions/StringEnum" }

      assert_equal("String", type.ruby_type_for(string_enum_ref))
    end

    def test_handle_ref_with_array_type
      definition = { "type" => "object", "properties" => {} }
      specification = {
        "definitions" => {
          "SimpleType" => { "type" => "object", "properties" => {} },
          "ArrayType" => {
            "type" => "array",
            "items" => { "$ref" => "#/definitions/SimpleType" },
          },
        },
      }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      array_type_ref = { "$ref" => "#/definitions/ArrayType" }

      assert_equal("[SimpleType]", type.ruby_type_for(array_type_ref))
    end

    def test_handle_ref_with_array_type_comment
      definition = { "type" => "object", "properties" => {} }
      specification = {
        "definitions" => {
          "SimpleType" => { "type" => "object", "properties" => {} },
          "ArrayType" => {
            "type" => "array",
            "items" => { "$ref" => "#/definitions/SimpleType" },
          },
        },
      }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      array_type_ref = { "$ref" => "#/definitions/ArrayType" }

      assert_equal("Array<SimpleType>", type.ruby_type_for(array_type_ref, for_comment: true))
    end

    def test_format_property_comment_with_description
      definition = { "type" => "object", "properties" => {} }
      specification = { "definitions" => {} }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      prop_with_desc = { "type" => "string", "description" => "The name of the item" }
      comment = type.send(:format_property_comment, prop_with_desc)

      assert_match(/@return \[String\] The name of the item/, comment)
    end

    def test_format_property_comment_without_description
      definition = { "type" => "object", "properties" => {} }
      specification = { "definitions" => {} }
      type = Type.new("SimpleType", definition, API_NAME, specification)

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
      specification = { "definitions" => {} }
      type = Type.new("RequiredTest", definition, API_NAME, specification)

      assert_equal(["id", "name"], type.required_properties)
    end

    def test_no_required_properties
      definition = {
        "type" => "object",
        "properties" => {
          "name" => { "type" => "string" },
        },
      }
      specification = { "definitions" => {} }
      type = Type.new("SimpleType", definition, API_NAME, specification)

      assert_empty(type.required_properties)
    end
  end
end
