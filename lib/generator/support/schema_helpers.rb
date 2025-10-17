# frozen_string_literal: true

require_relative "../parsers/json_schema_extractor"
require_relative "../resolvers/type_resolver"
require_relative "formatter"

module Generator
  # Shared helper methods for schema-based generators (Notification, Report, Feed, Type)
  module SchemaHelpers
    include Formatter

    # Generate attribute name (underscore the property name)
    # For boolean attributes, strip is_ prefix for more idiomatic Ruby
    def attribute_name_for(prop_name, prop_def)
      underscored = prop_name.underscore
      if prop_def && (prop_def["type"] == "boolean" || prop_def["type"] == "bool")
        underscored.sub(/^is_/, "")
      else
        underscored
      end
    end

    # Check if description is a generic placeholder from Amazon's schema generator
    def generic_placeholder?(description)
      return false unless description

      description.match?(/^An explanation about the purpose of this instance\.?$/i)
    end

    # Check if any types use Money
    def needs_money?(extracted_types = nil)
      # If extracted_types provided, check them directly
      if extracted_types
        return extracted_types.any? do |_type_name, type_def|
          type_def["properties"]&.any? do |_prop_name, prop_def|
            prop_def["$ref"] == "#/definitions/Money" ||
                (prop_def["items"].is_a?(Hash) && prop_def["items"]["$ref"] == "#/definitions/Money")
          end
        end
      end

      # Otherwise check properties (for Type class)
      return false unless respond_to?(:properties)

      properties.any? do |_prop_name, prop_def|
        if prop_def["$ref"]
          type_name = prop_def["$ref"].split("/").last
          TypeResolver::MONEY_TYPES.include?(type_name)
        else
          false
        end
      end
    end

    # Get list of all nested type file names for requiring
    # This method requires schema and a name method to be available
    def nested_type_files
      extractor = JsonSchemaExtractor.new(schema, send(:name))
      extracted_types = extractor.extract_types

      # Return list of underscored type names for requiring
      extracted_types.keys.map(&:underscore).sort
    end

    # Format property comment with description
    # base_indent can be overridden by subclasses
    def format_property_comment(prop_def, base_indent: 0)
      return_type = ruby_type_for(prop_def, for_comment: true)
      if prop_def["description"] && !prop_def["description"].empty? && !generic_placeholder?(prop_def["description"])
        description = convert_html_links_to_yard(prop_def["description"])
        description = convert_doc_links_to_full_url(description)
        split_long_comment_line("@return [#{return_type}] #{description}", base_indent: base_indent, wrap_indent: 2)
      else
        indent = " " * base_indent
        "#{indent}# @return [#{return_type}]"
      end
    end

    # Convert JSON Schema type to Ruby type
    # This method requires type_resolver to be available
    def ruby_type_for(prop_def, for_comment: false, for_rbs: false, prop_name: nil)
      type_resolver.resolve(prop_def, for_comment: for_comment, for_rbs: for_rbs, prop_name: prop_name)
    end

    # Build type resolver - this should be overridden by subclasses if needed
    # Default implementation for Notification/Report/Feed
    def type_resolver
      @type_resolver ||= begin
        # Build specification with extracted types for resolver
        extractor = JsonSchemaExtractor.new(schema, send(:name))
        extracted_types = extractor.extract_types
        spec = { "definitions" => extracted_types }
        TypeResolver.new(send(:name), spec, send(:api_name_for_type_resolver))
      end
    end

    # Hook for subclasses to provide the api_name for type resolver
    # Should be overridden in Notification/Report/Feed
    def api_name_for_type_resolver
      raise NotImplementedError, "Subclass must implement api_name_for_type_resolver"
    end

    # Generate nested types using the Type generator
    # Returns hash with :files (array of file paths) and :types (array of Type instances)
    def generate_nested_types!
      extractor = JsonSchemaExtractor.new(schema, send(:name))
      extracted_types = extractor.extract_types

      # Convert to OpenAPI-style specification for Type generator
      openapi_spec = {
        "definitions" => extracted_types,
      }

      # Generate each nested type and collect written files and Type instances
      written_files = []
      type_instances = []

      extracted_types.each do |type_name, type_def|
        api_name = api_name_for_type_resolver
        type = Type.new(type_name, type_def, api_name, openapi_spec)
        written_files << type.generate
        type_instances << type
      end

      { files: written_files, types: type_instances }
    end

    # Generate consolidated RBS signature for all types
    def generate_rbs!(all_types)
      api_name = api_name_for_type_resolver
      Generator::RBS::Types.new(api_name, all_types).generate
    end
  end
end
