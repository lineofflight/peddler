# frozen_string_literal: true

require "fileutils"
require "open3"

require "generator/config"
require "generator/api"
require "generator/entrypoint"

# @!visibility private
module Generator
  class << self
    def generate
      ensure_api_models_exist
      initialize_directory
      generate_apis
      generate_entry_point
      run_rubocop
    end

    private

    def ensure_api_models_exist
      api_models_dir = File.join(Config::BASE_PATH, "selling-partner-api-models")

      if !Dir.exist?(api_models_dir) || Dir.empty?(api_models_dir)
        puts "Cloning Amazon Selling Partner API models..."
        # Remove directory if it exists but is empty
        FileUtils.rm_rf(api_models_dir) if Dir.exist?(api_models_dir)

        # Clone the repository
        repo_url = "https://github.com/amzn/selling-partner-api-models.git"
        _stdout, stderr, status = Open3.capture3("git", "clone", repo_url, api_models_dir)

        unless status.success?
          raise "Failed to clone API models: #{stderr}"
        end

        puts "Successfully cloned API models."
      else
        puts "Using existing API models."
      end
    end

    def initialize_directory
      output_dir = File.join(Config::BASE_PATH, "lib/peddler/apis")
      FileUtils.rm_rf(output_dir)
      FileUtils.mkdir_p(output_dir)
    end

    def generate_apis
      apis.each(&:generate)
    end

    def generate_entry_point
      Entrypoint.new(apis).generate
    end

    def run_rubocop
      unless system("bundle exec rubocop --version > /dev/null 2>&1")
        raise "RuboCop is not available in the bundle. Please add it to your Gemfile or run 'bundle install'."
      end

      output, status = Open3.capture2e("bundle exec rubocop --format simple --autocorrect " \
        "#{File.join(Config::BASE_PATH, "lib")}")

      unless status.success?
        raise "RuboCop formatting failed:\n#{output}"
      end

      puts "Code formatted successfully with RuboCop."
    end

    def apis
      api_model_files.map { |file| API.new(file) }
    end

    def api_model_files
      Dir.glob(File.join(Config::BASE_PATH, "selling-partner-api-models/models/**/*.json"))
    end
  end
end
