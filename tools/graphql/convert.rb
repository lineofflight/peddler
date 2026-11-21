# frozen_string_literal: true

# Development-only SDL conversion. Runtime consumers use committed Rust models.
require "json"
require "graphql"
require_relative "../../lib/generator/parsers/graphql_type_extractor"

module Generator
  class RustGraphqlTypeExtractor < GraphqlTypeExtractor
    def extract_types
      definitions = super
      graphql_schema.types.each_value do |type|
        next if type.graphql_name.start_with?("__")
        if type.kind.enum?
          definitions[type.graphql_name] = { "type" => "string", "enum" => type.values.keys }
        end
      end
      definitions["Response"] = convert_graphql_type_to_definition(graphql_schema.query)
      definitions
    end

    private

    # Preserve nested list and element nullability. Every selected object field
    # remains optional, including fields marked non-null in SDL.
    def graphql_type_to_json_type(type)
      return non_null_type(type.of_type) if type.non_null?

      { "anyOf" => [non_null_type(type), { "type" => "null" }] }
    end

    def non_null_type(type)
      return { "type" => "array", "items" => graphql_type_to_json_type(type.of_type) } if type.list?

      case type.graphql_name
      when "String", "ID", "Date", "DateTime"
        { "type" => "string" }
      when "Int"
        { "type" => "integer", "format" => "int32" }
      when "Long"
        { "type" => "integer", "format" => "int64" }
      when "Float"
        { "type" => "number" }
      when "Boolean"
        { "type" => "boolean" }
      else
        raise "Unsupported scalar #{type.graphql_name}" if type.kind.scalar?

        { "$ref" => "#/definitions/#{type.graphql_name}" }
      end
    end
  end
end

schema = GraphQL::Schema.from_definition(File.read(ARGV.fetch(0)))
puts JSON.generate("definitions" => Generator::RustGraphqlTypeExtractor.new(schema, "Rust").extract_types)
