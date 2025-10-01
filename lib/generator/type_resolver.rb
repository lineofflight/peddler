# frozen_string_literal: true

module Generator
  # Resolves OpenAPI types to Ruby types for code generation
  class TypeResolver
    MONEY_TYPES = ["Money", "MoneyType", "Currency", "CurrencyAmount"].freeze

    attr_reader :type_name, :specification

    class << self
      def money?(name)
        MONEY_TYPES.include?(name)
      end
    end

    def initialize(type_name, specification)
      @type_name = type_name
      @specification = specification
    end

    def resolve(prop_def, for_comment: false, for_rbs: false)
      return (for_rbs ? "Hash[untyped, untyped]" : "Hash") unless prop_def.is_a?(Hash)

      if prop_def["$ref"]
        resolve_ref_type(prop_def["$ref"], for_comment, for_rbs)
      else
        resolve_inline_type(prop_def, for_comment, for_rbs)
      end
    end

    def generated_type?(name)
      return false if name.nil?
      return false unless specification && specification["definitions"]

      type_def = specification["definitions"][name]
      return false unless type_def

      # Only object types and allOf compositions get generated as separate files
      # Money-related types are handled specially
      # Types with additionalProperties are treated as Hash and not generated
      (type_def["type"] == "object" || type_def["allOf"]) && !money?(name) && !type_def["additionalProperties"]
    end

    private

    def money?(name)
      self.class.money?(name)
    end

    def resolve_ref_type(ref, for_comment, for_rbs = false)
      ref_name = ref.split("/").last

      # Special handling for Money types
      return "Money" if money?(ref_name)

      # Handle self-referential types
      return ":self" if ref_name == type_name

      # Check if this is a generated type
      return ref_name.camelize if generated_type?(ref_name)

      # For non-object types, resolve their actual type
      resolve_ref_definition(ref_name, for_comment, for_rbs)
    end

    def resolve_ref_definition(ref_name, for_comment, for_rbs = false)
      ref_def = specification&.dig("definitions", ref_name)
      return "String" unless ref_def

      case ref_def["type"]
      when "string"
        "String"
      when "array"
        resolve_ref_array(ref_def, for_comment, for_rbs)
      when "integer"
        "Integer"
      when "number"
        "Float"
      when "boolean"
        ":boolean"
      else
        for_rbs ? "Hash[untyped, untyped]" : "Hash"
      end
    end

    def resolve_ref_array(ref_def, for_comment, for_rbs = false)
      return (for_rbs ? "Array[untyped]" : "Array") unless ref_def["items"]

      if ref_def["items"]["$ref"]
        # Handle $ref case (reference to another type)
        item_type = ref_def["items"]["$ref"].split("/").last

        if for_comment
          "Array<#{item_type}>"
        elsif generated_type?(item_type)
          "[#{item_type.camelize}]"
        else
          for_rbs ? "Array[untyped]" : "Array"
        end
      elsif ref_def["items"]["type"]
        # Handle primitive type case (string, integer, etc.)
        resolve_array_with_type(ref_def["items"]["type"], for_comment, for_rbs)
      else
        for_rbs ? "Array[untyped]" : "Array"
      end
    end

    def resolve_inline_type(prop_def, for_comment, for_rbs = false)
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
        resolve_array_type(prop_def, for_comment, for_rbs)
      when "object"
        for_rbs ? "Hash[untyped, untyped]" : "Hash"
      else
        "String"
      end
    end

    def resolve_array_type(prop_def, for_comment, for_rbs = false)
      return (for_rbs ? "Array[untyped]" : "Array") unless prop_def["items"]

      if prop_def["items"]["$ref"]
        resolve_array_with_ref(prop_def["items"]["$ref"], for_comment, for_rbs)
      elsif prop_def["items"]["type"]
        resolve_array_with_type(prop_def["items"]["type"], for_comment, for_rbs)
      else
        for_rbs ? "Array[untyped]" : "Array"
      end
    end

    def resolve_array_with_ref(ref, for_comment, for_rbs = false)
      item_type = ref.split("/").last

      # Check if this is a self-referential array (direct property, not via another type)
      if item_type == type_name
        return for_comment ? "Array<self>" : "[:self]"
      end

      if for_comment
        "Array<#{item_type}>"
      elsif generated_type?(item_type)
        "[#{item_type.camelize}]"
      else
        for_rbs ? "Array[untyped]" : "Array"
      end
    end

    def resolve_array_with_type(item_type, for_comment, for_rbs = false)
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
          for_rbs ? "Array[untyped]" : "Array"
        end
      end
    end
  end
end
