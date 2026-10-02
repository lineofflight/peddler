# frozen_string_literal: true

require "json"
require "erb"
require "parallel"

require_relative "support/logger"
require_relative "support/config"
require_relative "support/formatter"
require_relative "support/file_writer"
require_relative "support/introspection_loader"
require_relative "support/money_detector"
require_relative "support/naming"
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

    INVENTORY = "crates/peddler-codegen/operation-inventory.json"

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
      model["definitions"].each do |name, definition|
        # Skip non-object definitions but allow allOf compositions and arrays
        next unless definition["type"] == "object" || definition["allOf"] || definition["type"] == "array"
        # Skip Money types as we use the custom Money type for these
        next if MoneyDetector.money_type?(name)
        # Skip types with ONLY additionalProperties (no defined properties) - they'll be referenced as Hash
        next if definition["additionalProperties"] && !definition["properties"] && !definition["allOf"]

        arr << Type.new(name, definition, name_with_version, model)
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

    # Typed success models by native operation key. The Rust generator owns the keys, so they are
    # read from its inventory by path and method.
    def parsers
      keys = native_keys

      paths.flat_map do |path|
        path.operations.filter_map do |op|
          next unless op.has_typed_response?

          key = keys.fetch([path.path, op.verb.upcase]) do
            raise "#{path.path} #{op.verb} of #{name_with_version} is missing from #{INVENTORY}"
          end

          [key, Naming.class_name(op.response_model[:model])]
        end
      end.sort.to_h
    end

    def paths
      model["paths"].map { |path, methods| Path.new(path, methods) }
    end

    def file_path
      File.join(Config::BASE_PATH, "lib/#{library_name}.rb")
    end

    def github_model_filename
      parts = file.split("/")
      "#{parts[-2]}/#{parts[-1]}"
    end

    private

    def render
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def template
      File.read(Config.template_path("api"))
    end

    def native_keys
      inventory = JSON.parse(File.read(File.join(Config::BASE_PATH, INVENTORY)))
      api = inventory["apis"].find { |entry| entry["module"] == name_with_version }
      raise "#{name_with_version} is missing from #{INVENTORY}" unless api

      api["operations"].to_h { |op| [[op["path"], op["method"]], op["key"]] }
    end

    def model
      @model ||= JSON.parse(File.read(file))
    end
  end
end
