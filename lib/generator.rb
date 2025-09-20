# frozen_string_literal: true

require "fileutils"
require "open3"

require "generator/config"
require "generator/logger"
require "generator/api"
require "generator/type"
require "generator/entrypoint"
require "generator/rbs_type"
require "generator/rbs_api"
require "generator/rbs_entrypoint"

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
      generate_rbs_signatures!
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
      ["apis", "types"].each do |dir_name|
        dir_path = File.join(Config::BASE_PATH, "lib/peddler/#{dir_name}")
        FileUtils.rm_rf(dir_path)
        FileUtils.mkdir_p(dir_path)
      end

      # Initialize RBS directories
      ["peddler/apis", "peddler/types"].each do |dir_name|
        dir_path = File.join(Config::BASE_PATH, "sig/#{dir_name}")
        FileUtils.rm_rf(dir_path)
        FileUtils.mkdir_p(dir_path)
      end

      logger.info("Initialized directories")
    end

    def generate_apis!
      api_count = apis.size
      apis.each(&:generate)

      logger.info("Generated #{api_count} APIs")
    end

    def generate_types!
      type_count = types.count
      types.each(&:generate)

      logger.info("Generated #{type_count} types")
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

    def generate_rbs_signatures!
      # Generate RBS signatures for types
      rbs_type_count = 0
      apis.each do |api|
        api.openapi_spec["definitions"]&.each do |name, definition|
          next unless definition["type"] == "object" || definition["allOf"] || definition["type"] == "array"
          next if name == "Money"

          type = Type.new(name, definition, api.name_with_version, api.openapi_spec)
          rbs_type = RBSType.new(type, api.name_with_version, api.openapi_spec)
          rbs_type.generate
          rbs_type_count += 1
        end
      end
      logger.info("Generated #{rbs_type_count} RBS type signatures")

      # Generate RBS signatures for APIs
      apis.each do |api|
        rbs_api = RBSApi.new(api, api.name_with_version)
        rbs_api.generate
      end
      logger.info("Generated #{apis.size} RBS API signatures")

      # Generate RBS entrypoint
      RBSEntrypoint.new(apis).generate
      logger.info("Generated RBS entrypoint")
    end

    def format_code!
      unless system("bundle exec rubocop --version > /dev/null 2>&1")
        raise "RuboCop is not available in the bundle. Please add it to your Gemfile or run 'bundle install'."
      end

      paths = [
        "lib/peddler.rb",
        "lib/peddler/apis",
        "lib/peddler/types",
      ]

      paths.each do |path|
        success = system("bundle exec rubocop --format simple --autocorrect-all --fail-level E #{path} > /dev/null 2>&1")

        unless success
          raise "Formatting failed for #{path}"
        end

        logger.info("Formatted #{path}")
      end
    end

    def apis
      @apis ||= api_model_files.map { |file| API.new(file) }
    end

    def types
      arr = []

      apis.each do |api|
        api.openapi_spec["definitions"].each do |name, definition|
          # Skip non-object definitions (but allow allOf compositions and arrays)
          next unless definition["type"] == "object" || definition["allOf"] || definition["type"] == "array"
          # Skip Money types as we use the Money gem for these
          next if name == "Money"

          arr << Type.new(name, definition, api.name_with_version, api.openapi_spec)
        end
      end

      arr
    end

    def api_model_files
      Dir.glob(File.join(Config::BASE_PATH, "selling-partner-api-models/models/**/*.json"))
    end
  end
end
