# frozen_string_literal: true

require "fileutils"
require "open3"
require "pathname"
require "rbs"
require "rbs/sorter"
require "set"

require "generator/config"
require "generator/logger"
require "generator/api"
require "generator/api_name_resolver"
require "generator/type"
require "generator/type_resolver"
require "generator/circular_dependency_detector"
require "generator/entrypoint"
require "generator/rbs/api"
require "generator/rbs/entrypoint"
require "generator/rbs/types"

# NOTE: Test generation was explored but removed due to Amazon SP-API sandbox limitations. Most APIs require special
# roles (vendor, finance, restricted shipping) that aren't available in standard sandbox environments, resulting in ~60%
# of tests being skipped. Manual integration tests for core APIs provide better value than auto-generated tests that
# can't actually run.

# @!visibility private
module Generator
  class << self
    include Logger

    def generate(api_filter: nil)
      @api_filter = api_filter
      logger.info("Starting code generation#{" for #{api_filter}" if api_filter}!")

      ensure_api_models_exist!
      if api_filter
        cleanup_filtered_api_types!
      else
        initialize_directories!
      end
      generate_apis!
      generate_types!
      generate_types_index_files!
      generate_entry_point! unless api_filter
      generate_api_signatures!
      generate_type_signatures!
      generate_entry_point_for_signatures! unless api_filter
      sort_rbs_files!
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
        clone_api_models(api_models_dir)
      elsif models_older_than_one_day?(api_models_dir)
        logger.info("API models are over 1 day old, updating")
        update_api_models(api_models_dir)
      else
        logger.info("Existing API models found")
      end
    end

    def clone_api_models(api_models_dir)
      logger.info("Cloning Amazon Selling Partner API models")
      repo_url = "https://github.com/amzn/selling-partner-api-models.git"
      _stdout, stderr, status = Open3.capture3("git", "clone", repo_url, api_models_dir)

      raise "Failed to clone API models: #{stderr}" unless status.success?
    end

    def update_api_models(api_models_dir)
      _stdout, stderr, status = Open3.capture3("git", "-C", api_models_dir, "pull")

      raise "Failed to update API models: #{stderr}" unless status.success?
    end

    def models_older_than_one_day?(api_models_dir)
      git_dir = File.join(api_models_dir, ".git")
      return false unless Dir.exist?(git_dir)

      fetch_head = File.join(git_dir, "FETCH_HEAD")
      return true unless File.exist?(fetch_head)

      File.mtime(fetch_head) < Time.now - (24 * 60 * 60)
    end

    def initialize_directories!
      manual_type_files = ["money.rb", "money.rbs", "lwa_token.rb", "lwa_token.rbs"].freeze

      ["lib", "sig"].each do |base|
        apis_path = File.join(Config::BASE_PATH, base, "peddler/apis")
        FileUtils.rm_rf(apis_path)
        FileUtils.mkdir_p(apis_path)

        types_path = File.join(Config::BASE_PATH, base, "peddler/types")
        Dir.glob(File.join(types_path, "*")).each do |item|
          # Skip manual files that shouldn't be deleted
          basename = File.basename(item)
          next if manual_type_files.include?(basename)

          # Remove type directories and consolidated RBS files
          if File.directory?(item)
            FileUtils.rm_rf(item)
          elsif base == "sig" && item.end_with?(".rbs")
            # Remove consolidated type RBS files (e.g., orders_v0.rbs)
            File.delete(item)
          end
        end
      end

      logger.info("Initialized directories")
    end

    def cleanup_filtered_api_types!
      bases = ["lib", "sig"]
      apis.each do |api|
        bases.each do |base|
          # Remove the old type directory structure (if it exists from previous versions)
          api_types_path = File.join(Config::BASE_PATH, base, "peddler/types", api.name_with_version)
          FileUtils.rm_rf(api_types_path) if Dir.exist?(api_types_path)
        end
      end

      logger.info("Cleaned up type directories for filtered API(s)")
    end

    def generate_apis!
      APINameResolver.validate_no_unmapped_collisions!(api_model_files)
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
      # Group types by API and generate consolidated RBS files
      types_by_api = types.group_by(&:api_name)
      types_by_api.each do |api_name, api_types|
        RBS::Types.new(api_name, api_types).generate
      end
      logger.info("Generated type signatures for #{types_by_api.count} APIs (#{types.count} types total)")
    end

    def generate_entry_point_for_signatures!
      RBS::Entrypoint.new(apis).generate
      logger.info("Generated entry point for signatures")
    end

    def sort_rbs_files!
      rbs_files = Dir.glob(File.join(Config::BASE_PATH, "sig/**/*.rbs"))

      # Suppress RBS::Sorter's stdout logging
      original_stdout = $stdout
      $stdout = File.new(File::NULL, "w")

      rbs_files.each do |file|
        ::RBS::Sorter.new(Pathname(file)).run
      end

      $stdout = original_stdout
      logger.info("Sorted #{rbs_files.count} RBS files")
    end

    def format_code!
      system("bundle exec rubocop --version > /dev/null 2>&1") ||
        raise("RuboCop isn't available")

      paths = @api_filter ? ["lib/peddler/apis", "lib/peddler/types"] : ["lib/peddler.rb", "lib/peddler/apis", "lib/peddler/types"]
      paths.each do |path|
        # Get list of actual files to format
        files_to_format = if File.directory?(path)
          Dir.glob(File.join(path, "**/*.rb")).select { |f| should_format?(f) }
        elsif File.exist?(path)
          [path]
        else
          [] #: Array[String]
        end

        next if files_to_format.empty?

        # Format files in batches for better performance
        files_to_format.each_slice(100) do |batch|
          files_list = batch.join(" ")
          system("bundle exec rubocop --format simple --autocorrect-all --fail-level E #{files_list} > /dev/null 2>&1") ||
            raise("Couldn't format files in batch")
        end

        logger.info("Formatted #{path}")
      end
    end

    def should_format?(file)
      return true unless @api_filter

      # When filtering, only format files related to the filtered API
      apis.any? { |api| file.include?(api.name_with_version) }
    end

    def apis
      @apis ||= begin
        all_apis = api_model_files.map { |file| API.new(file) }
        filter = @api_filter
        if filter
          filtered = all_apis.select { |api| api.name_with_version.include?(filter) }
          logger.info("Filtered to #{filtered.count} API(s) matching '#{filter}'")
          filtered
        else
          all_apis
        end
      end
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
            # Skip types with additionalProperties - they'll be referenced as Hash
            next if definition["additionalProperties"]

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
