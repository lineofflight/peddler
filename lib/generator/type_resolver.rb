# frozen_string_literal: true

module Generator
  # Resolves OpenAPI types to Ruby types for code generation
  class TypeResolver
    attr_reader :type_name, :specification

    def initialize(type_name, specification)
      @type_name = type_name
      @specification = specification
    end

    def resolve(prop_def, for_comment: false)
      return "Hash" unless prop_def.is_a?(Hash)

      if prop_def["$ref"]
        resolve_ref_type(prop_def["$ref"], for_comment)
      else
        resolve_inline_type(prop_def, for_comment)
      end
    end

    def generated_type?(name)
      return false unless specification && specification["definitions"]

      type_def = specification["definitions"][name]
      return false unless type_def

      # Only object types and allOf compositions get generated as separate files
      (type_def["type"] == "object" || type_def["allOf"]) && name != "Money"
    end

    private

    def resolve_ref_type(ref, for_comment)
      ref_name = ref.split("/").last

      # Special handling for Money types
      return "Types::Money" if money_type?(ref_name)

      # Handle self-referential types
      return ":self" if ref_name == type_name

      # Check if this is a generated type
      return ref_name.camelize if generated_type?(ref_name)

      # For non-object types, resolve their actual type
      resolve_ref_definition(ref_name, for_comment)
    end

    def money_type?(name)
      name == "Money" || name == "MoneyType"
    end

    def resolve_ref_definition(ref_name, for_comment)
      ref_def = specification&.dig("definitions", ref_name)
      return "String" unless ref_def

      case ref_def["type"]
      when "string"
        "String"
      when "array"
        resolve_ref_array(ref_def, for_comment)
      when "integer"
        "Integer"
      when "number"
        "Float"
      when "boolean"
        ":boolean"
      else
        "Hash"
      end
    end

    def resolve_ref_array(ref_def, for_comment)
      return "Array" unless ref_def["items"] && ref_def["items"]["$ref"]

      item_type = ref_def["items"]["$ref"].split("/").last

      if for_comment
        "Array<#{item_type}>"
      elsif generated_type?(item_type)
        "[#{item_type.camelize}]"
      else
        "Array"
      end
    end

    def resolve_inline_type(prop_def, for_comment)
      case prop_def["type"]
      when "string"
        "String"
      when "integer"
        "Integer"
      when "number"
        "Float"
      when "boolean"
        ":boolean"
      when "array"
        resolve_array_type(prop_def, for_comment)
      when "object"
        "Hash"
      else
        "String"
      end
    end

    def resolve_array_type(prop_def, for_comment)
      return "Array" unless prop_def["items"]

      if prop_def["items"]["$ref"]
        resolve_array_with_ref(prop_def["items"]["$ref"], for_comment)
      elsif prop_def["items"]["type"]
        resolve_array_with_type(prop_def["items"]["type"], for_comment)
      else
        "Array"
      end
    end

    def resolve_array_with_ref(ref, for_comment)
      item_type = ref.split("/").last

      if for_comment
        "Array<#{item_type}>"
      elsif generated_type?(item_type)
        "[#{item_type.camelize}]"
      else
        "Array"
      end
    end

    def resolve_array_with_type(item_type, for_comment)
      if for_comment
        "Array<#{item_type.capitalize}>"
      else
        case item_type
        when "string"
          "[String]"
        when "integer"
          "[Integer]"
        when "number"
          "[Float]"
        when "boolean"
          "[:boolean]"
        else
          "Array"
        end
      end
    end
  end
end
