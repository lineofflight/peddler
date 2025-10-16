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
require_relative "parsers/graphql_type_extractor"
require_relative "builders/type"
require_relative "support/schema_helpers"
require_relative "rbs/types"

module Generator
  # Generates Ruby type classes for Data Kiosk GraphQL schemas
  class DataKiosk
    include FileWriter
    include SchemaHelpers
    include SchemaGenerator

    attr_reader :file_path, :graphql_schema

    class << self
      def schema_type
        "data_kiosk"
      end

      # Override to filter .graphql files
      def schema_files
        pattern = File.join(Config::BASE_PATH, "selling-partner-api-models/schemas/data-kiosk/*.graphql")
        Dir.glob(pattern)
      end
    end

    def initialize(file_path)
      @file_path = file_path
      @graphql_schema = parse_graphql_schema(File.read(file_path))
    end

    def generate
      written_files = []
      all_types = []

      # Generate nested types first
      nested_results = generate_nested_types!
      written_files.concat(nested_results[:files])
      all_types.concat(nested_results[:types])

      # Generate main module file
      written_files << generate_main_file!

      # Generate JSON introspection schema (don't format JSON files)
      generate_introspection_schema!

      # Reload and generate RBS
      IntrospectionLoader.reload
      written_files << generate_rbs!(all_types)

      # Format all files
      format_files(written_files)

      Generator.logger.info("Generated data_kiosk #{schema_name.underscore}")
    end

    # Extract schema name from filename
    # "analytics_salesAndTraffic_2024_04_24.graphql" => "SalesAndTraffic20240424"
    def schema_name
      base_name = File.basename(file_path, ".graphql")
      # Remove "analytics_" prefix
      name = base_name.sub(/^analytics_/, "")
      # Convert to PascalCase
      name.split("_").map { |part| part.split(/(?=[A-Z])/).map(&:capitalize).join }.join
    end

    def class_name
      schema_name.underscore.camelize
    end

    # Alias for schema_generator pattern (expects schema_type.singularize + "_name")
    alias_method :data_kiosk_name, :schema_name

    private

    def parse_graphql_schema(sdl)
      require "graphql"
      GraphQL::Schema.from_definition(sdl)
    end

    def name
      schema_name
    end

    def generate_nested_types!
      written_files = []
      type_instances = []

      extractor = GraphqlTypeExtractor.new(graphql_schema, schema_name)
      extracted_types = extractor.extract_types

      openapi_spec = { "definitions" => extracted_types }

      extracted_types.each do |type_name, type_def|
        api_name = "data_kiosk/#{schema_name.underscore}"
        type = Type.new(type_name, type_def, api_name, openapi_spec)
        written_files << type.generate
        type_instances << type
      end

      { files: written_files, types: type_instances }
    end

    def generate_introspection_schema!
      introspection = graphql_schema.execute(GraphQL::Introspection::INTROSPECTION_QUERY)
      json = JSON.pretty_generate(introspection.to_h)

      output_path = File.join(
        Config::BASE_PATH,
        "lib/peddler/data_kiosk/#{schema_name.underscore}.json",
      )

      write_file(output_path, json)
    end

    def main_template
      File.read(Config.template_path("data_kiosk"))
    end

    def output_file_path
      File.join(
        Config::BASE_PATH,
        "lib/peddler/data_kiosk/#{schema_name.underscore}.rb",
      )
    end
  end
end
