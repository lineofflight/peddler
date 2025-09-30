# frozen_string_literal: true

require "fileutils"
require "open3"
require "set"

require "generator/config"
require "generator/logger"
require "generator/api"
require "generator/type"
require "generator/type_resolver"
require "generator/circular_dependency_detector"
require "generator/entrypoint"
require "generator/rbs/api"
require "generator/rbs/entrypoint"

# NOTE: Test generation was explored but removed due to Amazon SP-API sandbox limitations. Most APIs require special
# roles (vendor, finance, restricted shipping) that aren't available in standard sandbox environments, resulting in ~60%
# of tests being skipped. Manual integration tests for core APIs provide better value than auto-generated tests that
# can't actually run.

# @!visibility private
module Generator
  class << self
    include Logger

    def generate
      logger.info("Starting code generation!")

      ensure_api_models_exist!
      initialize_directories!
      generate_apis!
      generate_types!
      generate_types_index_files!
      generate_entry_point!
      generate_api_signatures!
      generate_type_signatures!
      generate_entry_point_for_signatures!
      format_code!

      logger.info("Code generation completed successfully!")
    end

    private

    def ensure_api_models_exist!
      api_models_dir = File.join(Config::BASE_PATH, "selling-partner-api-models")

      # Remove directory if it exists but is empty
      if Dir.exist?(api_models_dir) && Dir.empty?(api_models_dir)
        FileUtils.rm_rf(api_models_dir)
      end

      if !Dir.exist?(api_models_dir)
        logger.info("Cloning Amazon Selling Partner API models")

        # Clone the repository
        repo_url = "https://github.com/amzn/selling-partner-api-models.git"
        _stdout, stderr, status = Open3.capture3("git", "clone", repo_url, api_models_dir)

        unless status.success?
          raise "Failed to clone API models: #{stderr}"
        end
      else
        logger.info("Existing API models found")
      end
    end

    def initialize_directories!
      ["lib", "sig"].each do |base|
        apis_path = File.join(Config::BASE_PATH, base, "peddler/apis")
        FileUtils.rm_rf(apis_path)
        FileUtils.mkdir_p(apis_path)

        types_path = File.join(Config::BASE_PATH, base, "peddler/types")
        Dir.glob(File.join(types_path, "*")).each do |item|
          FileUtils.rm_rf(item) if File.directory?(item)
        end
      end

      logger.info("Initialized directories")
    end

    def generate_apis!
      apis.each(&:generate)
      logger.info("Generated #{apis.count} APIs")
    end

    def generate_types!
      circular_count = types.find { |t| t.circular_dependencies&.any? }&.circular_dependencies&.size || 0
      logger.info("Detected circular dependencies in #{circular_count} types") if circular_count > 0

      types.each(&:generate)
      logger.info("Generated #{types.count} types")
    end

    def generate_types_index_files!
      types_index_template = File.read(Config.template_path("types"))

      apis.each do |api|
        index_file_path = File.join(Config::BASE_PATH, "lib/peddler/types/#{api.name_with_version}.rb")
        rendered_content = ERB.new(types_index_template, trim_mode: "-").result(api.instance_eval { binding })
        File.write(index_file_path, rendered_content)
      end

      logger.info("Generated types index files")
    end

    def generate_entry_point!
      Entrypoint.new(apis).generate
      logger.info("Generated entry point")
    end

    def generate_api_signatures!
      apis.each do |api|
        RBS::API.new(api, api.name_with_version).generate
      end
      logger.info("Generated #{apis.count} API signatures")
    end

    def generate_type_signatures!
      # Generate RBS for all types (both Structure and Array types)
      types.each(&:generate_rbs)
      logger.info("Generated #{types.count} type signatures")
    end

    def generate_entry_point_for_signatures!
      RBS::Entrypoint.new(apis).generate
      logger.info("Generated entry point for signatures")
    end

    def format_code!
      system("bundle exec rubocop --version > /dev/null 2>&1") ||
        raise("RuboCop isn't available")

      paths = ["lib/peddler.rb", "lib/peddler/apis", "lib/peddler/types"]
      paths.each do |path|
        system("bundle exec rubocop --format simple --autocorrect-all --fail-level E #{path} > /dev/null 2>&1") ||
          raise("Couldn't format #{path}")

        logger.info("Formatted #{path}")
      end
    end

    def apis
      @apis ||= api_model_files.map { |file| API.new(file) }
    end

    def types
      @types ||= begin
        arr = [] #: Array[Type]
        apis.each do |api|
          api.openapi_spec["definitions"].each do |name, definition|
            # Skip non-object definitions but allow allOf compositions and arrays
            next unless definition["type"] == "object" || definition["allOf"] || definition["type"] == "array"
            # Skip Money types as we use the custom Money type for these
            next if TypeResolver.money?(name)

            arr << Type.new(name, definition, api.name_with_version, api.openapi_spec)
          end
        end

        detector = CircularDependencyDetector.new(arr)
        detector.detect
        arr.each do |type|
          type.circular_dependencies = detector.circular_deps
          type.cycle_edges = detector.cycle_edges
        end

        arr
      end
    end

    def api_model_files
      Dir.glob(File.join(Config::BASE_PATH, "selling-partner-api-models/models/**/*.json"))
    end
  end
end
