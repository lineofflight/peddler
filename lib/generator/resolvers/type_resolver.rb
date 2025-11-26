# frozen_string_literal: true

require "active_support/inflector"
require_relative "../support/money_detector"
require_relative "../support/naming"

module Generator
  # Resolves OpenAPI types to Ruby types for code generation
  class TypeResolver
    attr_reader :type_name, :specification, :api_name

    def initialize(type_name, specification, api_name = nil)
      @type_name = type_name
      @specification = specification
      @api_name = api_name
    end

    def resolve(prop_def, for_comment: false, for_rbs: false, prop_name: nil)
      return (for_rbs ? "Hash[untyped, untyped]" : "Hash") unless prop_def.is_a?(Hash)

      if prop_def["$ref"]
        resolve_ref_type(prop_def["$ref"], for_comment, for_rbs)
      else
        resolve_inline_type(prop_def, for_comment, for_rbs, prop_name)
      end
    end

    def generated_type?(name)
      return false if name.nil?
      return false unless specification && specification["definitions"]

      # Try both the original name and PascalCase version
      # B2B schemas use lowercase refs (e.g., "sellerFeedbackRating") but extracted types use PascalCase
      type_def = specification["definitions"][name] || specification["definitions"][name.camelize]
      return false unless type_def

      # Only object types and allOf compositions get generated as separate files
      # Money-related types are handled specially
      # Types with ONLY additionalProperties (no defined properties) are treated as Hash
      return false if MoneyDetector.money_type?(name)
      return false if type_def["additionalProperties"] && !type_def["properties"] && !type_def["allOf"]

      type_def["type"] == "object" || type_def["allOf"]
    end

    private

    def resolve_ref_type(ref, for_comment, for_rbs = false)
      ref_name = ref.split("/").last

      # Special handling for Money types
      if MoneyDetector.money_type?(ref_name)
        # Money is at Peddler::Money
        # Just use "Money" - Ruby's constant lookup will find it in the Peddler namespace
        return "Money"
      end

      # Handle self-referential types
      return ":self" if ref_name == type_name

      # Check if this is a generated type
      return Naming.class_name(ref_name) if generated_type?(ref_name)

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
          "[#{Naming.class_name(item_type)}]"
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

    def resolve_inline_type(prop_def, for_comment, for_rbs = false, prop_name = nil)
      case prop_def["type"]
      when "string"
        resolve_string_type(prop_def)
      when "integer"
        "Integer"
      when "number"
        "Float"
      when "boolean"
        ":boolean"
      when "array"
        resolve_array_type(prop_def, for_comment, for_rbs)
      when "object"
        # Check if this inline object matches an extracted type
        if prop_name && prop_def["properties"]
          type_name = prop_name.camelize
          return Naming.class_name(type_name) if generated_type?(type_name)
        end
        for_rbs ? "Hash[untyped, untyped]" : "Hash"
      else
        "String"
      end
    end

    def resolve_string_type(prop_def)
      # Handle format hints for string types
      # Structure gem can parse these types if we require 'time' and 'uri'
      case prop_def["format"]
      when "date-time", "dateTime"
        "Time"
      when "date"
        "Date"
      when "uri"
        "URI"
      else
        "String"
      end
    end

    def resolve_array_type(prop_def, for_comment, for_rbs = false)
      return (for_rbs ? "Array[untyped]" : "Array") unless prop_def["items"]

      items = prop_def["items"]

      # Handle case where items is an array (non-standard but used by Amazon)
      # Example: "items": [{"$ref": "#/definitions/offerCount"}]
      items = items.first if items.is_a?(Array) && !items.empty?

      # Return untyped if items is still not a hash (empty array or other unexpected format)
      return (for_rbs ? "Array[untyped]" : "Array") unless items.is_a?(Hash)

      if items["$ref"]
        resolve_array_with_ref(items["$ref"], for_comment, for_rbs)
      elsif items["type"]
        resolve_array_with_type(items["type"], for_comment, for_rbs)
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
        "[#{Naming.class_name(item_type)}]"
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
