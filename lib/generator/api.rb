# frozen_string_literal: true

require "json"
require "erb"
require "parallel"

require_relative "support/logger"
require_relative "support/config"
require_relative "support/formatter"
require_relative "support/file_writer"
require_relative "support/introspection_loader"
require_relative "parsers/path"
require_relative "resolvers/type_resolver"
require_relative "resolvers/api_name_resolver"
require_relative "builders/type"
require_relative "analyzers/circular_dependency_detector"
require_relative "rbs/unified"

module Generator
  class API
    include FileWriter
    include Formatter

    attr_reader :file

    class << self
      def generate
        cleanup!

        # Generate each API in parallel
        Parallel.each(apis, &:generate)
      end

      def apis
        api_models = Dir.glob(File.join(Config::BASE_PATH, "selling-partner-api-models/models/**/*.json"))
        APINameResolver.validate_no_unmapped_collisions!(api_models)

        api_models.map { |file| new(file) }.sort_by do |api|
          version_key = api.version.start_with?("v") ? api.version : "z#{api.version}"
          [api.name, version_key]
        end
      end

      def cleanup!
        ["lib", "sig"].each do |base|
          apis_path = File.join(Config::BASE_PATH, base, "peddler/apis")
          FileUtils.mkdir_p(apis_path)
          # Delete only generated API subdirectories, preserve all files (money.rb, etc.)
          Dir.glob(File.join(apis_path, "*")).select { |p| File.directory?(p) }.each do |dir|
            FileUtils.rm_rf(dir)
          end
        end
      end
    end

    def initialize(file)
      @file = file
      @written_files = []
    end

    def generate
      generate_api_class!
      generate_types!

      # Reload to pick up newly generated files for RBS introspection
      IntrospectionLoader.reload
      generate_rbs!
      format_files(@written_files)

      Generator.logger.info("Generated api #{name_with_version}")
    end

    def generate_api_class!
      @written_files << write_file(file_path, render)
    end

    def generate_types!
      api_types = types
      return [] if api_types.empty?

      # Detect circular dependencies across all types for this API
      detector = CircularDependencyDetector.new(api_types)
      detector.detect
      api_types.each do |type|
        type.circular_dependencies = detector.circular_deps
        type.cycle_edges = detector.cycle_edges
      end

      # Generate each type Ruby file
      api_types.each do |type|
        @written_files << type.generate
      end

      # Store types for RBS generation
      @api_types = api_types
    end

    def generate_rbs!
      # Generate unified RBS file with both API operations and type definitions
      @written_files << RBS::Unified.new(self, name_with_version, @api_types || []).generate
    end

    def types
      arr = []
      openapi_spec["definitions"].each do |name, definition|
        # Skip non-object definitions but allow allOf compositions and arrays
        next unless definition["type"] == "object" || definition["allOf"] || definition["type"] == "array"
        # Skip Money types as we use the custom Money type for these
        next if TypeResolver.money?(name)
        # Skip types with ONLY additionalProperties (no defined properties) - they'll be referenced as Hash
        next if definition["additionalProperties"] && !definition["properties"] && !definition["allOf"]

        arr << Type.new(name, definition, name_with_version, openapi_spec)
      end
      arr
    end

    def title
      split_long_comment_line(model["info"]["title"], base_indent: 4)
    end

    def description
      description = model["info"]["description"]
      description = convert_html_links_to_yard(description)
      description = convert_doc_links_to_full_url(description)

      split_long_comment_line(description, base_indent: 4)
    end

    def library_name
      "peddler/apis/#{name_with_version}"
    end

    def has_helper?
      File.exist?("lib/" + helper_library_name + ".rb")
    end

    def helper_class_name
      "Peddler::Helpers::#{name_with_version.camelize}"
    end

    def helper_library_name
      "peddler/helpers/#{name_with_version}"
    end

    def class_name
      name_with_version.camelize
    end

    def name
      @name ||= APINameResolver.new(file).name
    end

    def version
      model["info"]["version"].tr("-", "_")
    end

    def name_with_version
      [name, version].join("_")
    end

    def latest_version?
      all_apis = self.class.apis.select { |api| api.name == name }
      latest_version = VersionSelector.find_latest_version(all_apis.map(&:version))
      version == latest_version
    end

    def convenience_method_name
      name
    end

    def operations
      @operations ||= begin
        ops = paths.flat_map { |path| path.operations(name_with_version) }.compact
        deduplicate_operations(ops)
      end
    end

    def type_names
      openapi_spec["definitions"]
        .select { |name, def_| def_["type"] == "object" && !TypeResolver::MONEY_TYPES.include?(name) && !def_["additionalProperties"] }
        .keys
        .sort
    end

    def paths
      model["paths"].map { |path, methods| Path.new(path, methods) }
    end

    def file_path
      File.join(Config::BASE_PATH, "lib/#{library_name}.rb")
    end

    def openapi_spec
      model
    end

    def github_model_filename
      parts = file.split("/")
      "#{parts[-2]}/#{parts[-1]}"
    end

    private

    def deduplicate_operations(ops)
      # Group by operation ID
      operation_map = ops.group_by { |op| op.operation["operationId"].underscore }

      # Find duplicates
      duplicates = operation_map.select { |_, ops| ops.size > 1 }

      if duplicates.any?
        duplicates.each do |method_name, ops|
          verbs = ops.map(&:verb).join(", ")
          Generator.logger.warn("Found duplicate operation in #{name_with_version}: #{method_name} (#{verbs})")
        end
      end

      # Handle duplicates
      duplicates.each do |method_name, ops|
        if name_with_version == "shipping_v2" && method_name == "link_carrier_account"
          # Special case for ShippingV2's link_carrier_account - choose POST version
          post_op = ops.find { |op| op.verb == "post" }
          operation_map[method_name] = [post_op] if post_op
        else
          # For any other duplicates, raise an error
          verbs = ops.map(&:verb).join(", ")
          raise "Error: Found duplicate operation '#{method_name}' in #{name_with_version} " \
            "with HTTP verbs: #{verbs}. Please handle this case specifically."
        end
      end

      # Return flattened list of operations with duplicates resolved
      operation_map.values.flatten
    end

    def render
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def template
      File.read(Config.template_path("api"))
    end

    def model
      @model ||= JSON.parse(File.read(file))
    end
  end
end
