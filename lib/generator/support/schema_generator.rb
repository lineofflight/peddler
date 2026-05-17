# frozen_string_literal: true

require "parallel"

module Generator
  # Shared functionality for schema-based generators (Notification, Report, Feed)
  # Provides common patterns for file discovery, cleanup, and generation
  module SchemaGenerator
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      # Generate all schema files in parallel
      def generate
        cleanup!
        Parallel.each(all_schemas, &:generate)
      end

      # Clean up generated files and directories for this schema type
      def cleanup!
        ["lib", "sig"].each do |base_dir|
          schemas_path = File.join(Config::BASE_PATH, base_dir, "peddler/#{schema_type}")
          FileUtils.rm_rf(schemas_path) if Dir.exist?(schemas_path)
        end
      end

      # Get all schema instances (memoized)
      def all_schemas
        instance_variable_get("@all_#{schema_type}") ||
          instance_variable_set("@all_#{schema_type}", schema_files.map { |file| new(file) })
      end

      # Find all schema files for this type
      def schema_files
        pattern = File.join(Config::BASE_PATH, "selling-partner-api-models/schemas/#{schema_type}/*.json")
        Dir.glob(pattern).then { |files| filter_schema_files(files) }
      end

      # Hook for subclasses to filter schema files (e.g., reject examples)
      # Override in subclass if needed
      def filter_schema_files(files)
        files
      end

      # Hook: schema type name (e.g., "notifications", "reports", "feeds")
      # Must be implemented by including class
      def schema_type
        raise NotImplementedError, "#{self} must implement .schema_type"
      end
    end

    # Instance-level shared methods

    # Template method: generate every file for a single schema. Per-type
    # specifics are supplied via the generate_schema_types and
    # generate_supplementary_files hooks.
    def generate
      written_files = []
      all_types = []

      # Generate nested types first
      nested_results = generate_nested_types!
      written_files.concat(nested_results[:files])
      all_types.concat(nested_results[:types])

      generate_schema_types(written_files, all_types)

      # Generate main convenience file
      written_files << generate_main_file!

      generate_supplementary_files(written_files, all_types)

      # Reload to pick up newly generated files for RBS introspection
      IntrospectionLoader.reload
      written_files << generate_rbs!(all_types)

      # Batch format all written files
      format_files(written_files)

      singular = self.class.schema_type.singularize
      Generator.logger.info("Generated #{singular} #{send("#{singular}_name").underscore}")
    end

    # Hook: append the primary schema type(s) to written_files/all_types.
    # Default no-op (Data Kiosk has no standalone main type).
    def generate_schema_types(_written_files, _all_types); end

    # Hook: generate extra files after the main convenience file. Default no-op.
    def generate_supplementary_files(_written_files, _all_types); end

    # Generate main convenience file using ERB template
    def generate_main_file!
      content = ERB.new(main_template, trim_mode: "-").result(binding)
      write_file(output_file_path, content)
    end

    # Sort properties (natural alphabetical order by default)
    # Can be overridden for custom sorting
    def sorted_properties(props)
      props.sort.to_h
    end

    # Get main template content
    def main_template
      template_name = self.class.name.split("::").last.underscore
      File.read(Config.template_path(template_name))
    end

    # Get output file path for main file
    def output_file_path
      schema_name_method = "#{self.class.schema_type.singularize}_name"
      schema_name = send(schema_name_method)
      File.join(
        Config::BASE_PATH,
        "lib/peddler/#{self.class.schema_type}/#{schema_name.underscore}.rb",
      )
    end

    # Check if any types use Money (shared implementation)
    def needs_money?
      extractor = JsonSchemaExtractor.new(schema, send(:name))
      extracted_types = extractor.extract_types
      super(extracted_types)
    end

    private

    # Provide the api_name for type resolver (common pattern)
    def api_name_for_type_resolver
      schema_type = self.class.schema_type.singularize
      "#{self.class.schema_type}/#{send("#{schema_type}_name").underscore}"
    end
  end
end
