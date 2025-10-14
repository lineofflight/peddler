# frozen_string_literal: true

require "erb"
require "fileutils"
require "json"
require "parallel"

require_relative "logger"
require_relative "config"
require_relative "support/file_writer"
require_relative "support/schema_generator"
require_relative "support/introspection_loader"
require_relative "parsers/json_schema_extractor"
require_relative "type"
require_relative "support/schema_helpers"
require_relative "rbs/types"

module Generator
  # Generates Ruby type classes for SP-API report schemas from JSON Schema files
  class Report
    include FileWriter
    include SchemaHelpers
    include SchemaGenerator

    attr_reader :file_path, :schema

    class << self
      def schema_type
        "reports"
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

      # Generate main report type
      report_result = generate_report_type!
      written_files << report_result[:file]
      all_types << report_result[:type]

      # Generate main convenience file
      written_files << generate_main_file!

      # Reload to pick up newly generated files for RBS introspection
      IntrospectionLoader.reload
      written_files << generate_rbs!(all_types)

      # Batch format all written files
      format_files(written_files)

      Generator.logger.info("Generated #{report_name}")
    end

    # Extract report name from filename
    # Examples:
    #   "endUserDataReport.json" => "EndUserData"
    #   "accountHealthReport-2020-11-18.json" => "AccountHealth_2020_11_18"
    #   "b2bProductOpportunitiesNotYetOnAmazonReport-2020-11-19.json" => "B2bProductOpportunitiesNotYetOnAmazon_2020_11_19"
    def report_name
      base_name = File.basename(file_path, ".json")
      # Remove "Report" suffix
      name = base_name.sub(/Report$/, "")
      # Convert dashes to underscores for valid Ruby identifiers
      name.tr("-", "_")
    end

    # Class name for the report (e.g., "EndUserData", "AccountHealth_2020_11_18")
    def class_name
      # Underscore first to ensure ActiveSupport::Inflector applies acronym rules correctly
      report_name.underscore.camelize
    end

    # Root properties from schema (excluding reportSpecification which is metadata)
    def root_properties
      props = schema["properties"] || {}
      sorted_properties(props)
    end

    # Required properties from root level
    def root_required_properties
      schema["required"] || []
    end

    # Raw description from schema (will be formatted by Type class)
    def raw_description
      return unless schema["description"]
      return if generic_placeholder?(schema["description"])

      schema["description"]
    end

    private

    # Provide the name for schema extraction
    def name
      report_name
    end

    # Build Report type definition
    def report_type_definition
      {
        "type" => "object",
        "description" => raw_description || "SP-API Report data",
        "properties" => root_properties,
        "required" => root_required_properties,
      }
    end

    def generate_report_type!
      # Build spec with all extracted types
      extractor = JsonSchemaExtractor.new(schema, report_name)
      extracted_types = extractor.extract_types

      openapi_spec = {
        "definitions" => extracted_types,
      }

      api_name = "reports/#{report_name.underscore}"
      report_type = Type.new("Report", report_type_definition, api_name, openapi_spec)
      file_path = report_type.generate

      { file: file_path, type: report_type }
    end
  end
end
