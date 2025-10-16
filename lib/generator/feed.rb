# frozen_string_literal: true

require "erb"
require "fileutils"
require "json"
require "parallel"

require_relative "support/logger"
require_relative "support/config"
require_relative "support/file_writer"
require_relative "support/schema_generator"
require_relative "support/introspection_loader"
require_relative "parsers/json_schema_extractor"
require_relative "builders/type"
require_relative "support/schema_helpers"
require_relative "rbs/types"

module Generator
  # Generates Ruby type classes for SP-API feed schemas from JSON Schema files
  class Feed
    include FileWriter
    include SchemaHelpers
    include SchemaGenerator

    attr_reader :file_path, :schema

    class << self
      def schema_type
        "feeds"
      end

      # Override to filter out example files
      def filter_schema_files(files)
        files.reject { |file| file.include?(".example.") }
      end
    end

    def initialize(file_path)
      @file_path = file_path
      @schema = JSON.parse(File.read(file_path))
    end

    def generate
      written_files = []
      all_types = []

      # Generate nested types first
      nested_results = generate_nested_types!
      written_files.concat(nested_results[:files])
      all_types.concat(nested_results[:types])

      # Generate main feed type
      feed_result = generate_feed_type!
      written_files << feed_result[:file]
      all_types << feed_result[:type]

      # Generate main convenience file
      written_files << generate_main_file!

      # Reload to pick up newly generated files for RBS introspection
      IntrospectionLoader.reload
      written_files << generate_rbs!(all_types)

      # Batch format all written files
      format_files(written_files)

      Generator.logger.info("Generated #{feed_name}")
    end

    # Extract feed name from filename
    # Examples:
    #   "listings-feed-schema-v2.json" => "ListingsFeedSchema"
    #   "listings-feed-message-schema-v2.json" => "ListingsFeedMessageSchema"
    #   "listings-feed-processing-report-schema-v2.json" => "ListingsFeedProcessingReportSchema"
    def feed_name
      base_name = File.basename(file_path, ".json")
      # Remove version suffix (e.g., "-v2")
      name = base_name.sub(/-v\d+$/, "")
      # Convert to PascalCase, treating "feed" and "schema" as separate words
      name.split("-").map(&:capitalize).join
    end

    # Class name for the feed (e.g., "ListingsFeedSchema")
    def class_name
      # Underscore first to ensure ActiveSupport::Inflector applies acronym rules correctly
      feed_name.underscore.camelize
    end

    # Root properties from schema
    def root_properties
      props = schema["properties"] || {}
      sorted_properties(props)
    end

    # Required properties from root level
    def root_required_properties
      schema["required"] || []
    end

    # Class description from schema
    # Raw description from schema (will be formatted by Type class)
    def raw_description
      return unless schema["title"] || schema["description"]

      description = schema["title"] || schema["description"]
      return if generic_placeholder?(description)

      description
    end

    private

    # Provide the name for schema extraction
    def name
      feed_name
    end

    # Build Feed type definition with $ref to extracted types
    def feed_type_definition
      # Get extracted types to know which properties should be replaced with $ref
      extractor = JsonSchemaExtractor.new(schema, feed_name)
      extracted_types = extractor.extract_types

      # Replace root properties with $ref when a corresponding type exists
      updated_properties = root_properties.transform_values do |prop_def|
        replace_with_ref_if_extracted(prop_def, extracted_types)
      end

      {
        "type" => "object",
        "description" => raw_description || "SP-API Feed data",
        "properties" => updated_properties,
        "required" => root_required_properties,
      }
    end

    # Replace property definition with $ref if a corresponding type was extracted
    def replace_with_ref_if_extracted(prop_def, extracted_types)
      # Handle object properties
      return replace_object_with_ref(prop_def, extracted_types) if object_property?(prop_def)

      # Handle array properties with object items
      return replace_array_items_with_ref(prop_def, extracted_types) if array_with_object_items?(prop_def)

      # Return original if no replacement needed
      prop_def
    end

    def object_property?(prop_def)
      prop_def["type"] == "object" && prop_def["properties"]
    end

    def array_with_object_items?(prop_def)
      prop_def["type"] == "array" && prop_def["items"] &&
        prop_def["items"]["type"] == "object" && prop_def["items"]["properties"]
    end

    def replace_object_with_ref(prop_def, extracted_types)
      prop_name = root_properties.find { |_k, v| v == prop_def }&.first
      return prop_def unless prop_name

      type_name = prop_name.camelize
      return prop_def unless extracted_types.key?(type_name)

      {
        "$ref" => "#/definitions/#{type_name}",
        "description" => prop_def["description"],
      }.compact
    end

    def replace_array_items_with_ref(prop_def, extracted_types)
      items = prop_def["items"]

      # Skip arrays with additionalProperties: true (flexible structure)
      return prop_def if items["additionalProperties"] == true && items["minProperties"]

      prop_name = root_properties.find { |_k, v| v == prop_def }&.first
      return prop_def unless prop_name

      type_name = prop_name.singularize.camelize
      return prop_def unless extracted_types.key?(type_name)

      {
        "type" => "array",
        "description" => prop_def["description"],
        "items" => {
          "$ref" => "#/definitions/#{type_name}",
        },
      }.compact
    end

    def generate_feed_type!
      # Build spec with all extracted types
      extractor = JsonSchemaExtractor.new(schema, feed_name)
      extracted_types = extractor.extract_types

      openapi_spec = {
        "definitions" => extracted_types,
      }

      api_name = "feeds/#{feed_name.underscore}"
      feed_type = Type.new("Feed", feed_type_definition, api_name, openapi_spec)
      file_path = feed_type.generate

      { file: file_path, type: feed_type }
    end
  end
end
