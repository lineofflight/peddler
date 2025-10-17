# frozen_string_literal: true

require "active_support/inflector"

module Generator
  # Extracts nested type definitions from GraphQL schemas
  # Converts GraphQL type system to OpenAPI-style definitions for Type generation
  class GraphqlTypeExtractor
    BUILTIN_TYPES = ["Query", "String", "Int", "Float", "Boolean", "ID", "Date", "DateTime"].freeze
    private_constant :BUILTIN_TYPES

    attr_reader :graphql_schema, :schema_name

    def initialize(graphql_schema, schema_name)
      @graphql_schema = graphql_schema
      @schema_name = schema_name
      @extracted_types = {}
    end

    # Extract all types from GraphQL schema
    # Returns hash of type_name => definition (OpenAPI-style)
    def extract_types
      graphql_schema.types.each do |type_name, type_obj|
        # Skip built-in GraphQL types
        next if type_name.start_with?("__")
        next if BUILTIN_TYPES.include?(type_name)

        # Skip root query types (e.g., Analytics_SalesAndTraffic_2024_04_24)
        next if type_obj == graphql_schema.query

        # Skip enums (handle separately if needed in the future)
        next if type_obj.kind.enum?

        # Extract object types only
        if type_obj.kind.object?
          @extracted_types[type_name] = convert_graphql_type_to_definition(type_obj)
        end
      end

      @extracted_types
    end

    private

    def convert_graphql_type_to_definition(type_obj)
      {
        "type" => "object",
        "description" => type_obj.description,
        "properties" => extract_properties(type_obj),
        "required" => extract_required_fields(type_obj),
      }.compact
    end

    def extract_properties(type_obj)
      properties = {}
      type_obj.fields.each do |field_name, field|
        type_def = graphql_type_to_json_type(field.type)
        # If the type is a complex object (Hash with $ref, type, etc.), use it directly
        # Otherwise wrap it in { "type" => ... }
        properties[field_name] = if type_def.is_a?(Hash)
          type_def.merge("description" => field.description).compact
        else
          {
            "type" => type_def,
            "description" => field.description,
          }.compact
        end

        # Mark non-null fields for Structure's null: false option
        properties[field_name]["x-non-null"] = true if field.type.non_null?
      end
      properties
    end

    def extract_required_fields(type_obj)
      # For GraphQL schemas (Data Kiosk), all fields should be optional because:
      # 1. GraphQL queries return only the fields explicitly requested
      # 2. Fields not included in the query are absent from the response
      # 3. The `!` marker in GraphQL means "if present, cannot be null",
      #    not "must always be present"
      #
      # By returning an empty array, all fields will use attribute?() which allows
      # them to be absent from parsed JSON, matching GraphQL's actual behavior.
      #
      # Non-null constraints are handled separately via the "x-non-null" property flag,
      # which translates to Structure's `null: false` option.
      []
    end

    def graphql_type_to_json_type(graphql_type)
      # Unwrap NonNull and List wrappers
      inner_type = graphql_type
      is_array = false

      # Unwrap NonNull first
      inner_type = inner_type.of_type if inner_type.non_null?

      # Then check if it's a list
      if inner_type.list?
        is_array = true
        inner_type = inner_type.of_type
      end

      # Unwrap NonNull from inner type if present (for cases like [Type!])
      inner_type = inner_type.of_type if inner_type.non_null?

      # Map GraphQL scalar types to JSON Schema types
      json_type = case inner_type.graphql_name
      when "String", "ID", "Date", "DateTime"
        "string"
      when "Int"
        "integer"
      when "Float"
        "number"
      when "Boolean"
        "boolean"
      else
        # Reference to another type
        return is_array ? {
          "type" => "array",
          "items" => { "$ref" => "#/definitions/#{inner_type.graphql_name}" },
        } : {
          "$ref" => "#/definitions/#{inner_type.graphql_name}",
        }
      end

      if is_array
        {
          "type" => "array",
          "items" => { "type" => json_type },
        }
      else
        json_type
      end
    end
  end
end
