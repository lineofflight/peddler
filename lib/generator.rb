# frozen_string_literal: true

require "fileutils"

require "generator/config"
require "generator/api"
require "generator/entrypoint"

# @!visibility private
module Generator
  class << self
    def generate
      initialize_directory
      generate_apis
      generate_entry_point
      run_rubocop
    end

    private

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

      %x(bundle exec rubocop --format simple --autocorrect #{File.join(Config::BASE_PATH, "lib")} 2>&1)
    end

    def apis
      api_model_files.map { |file| API.new(file) }.reject(&:obsolete?)
    end

    def api_model_files
      Dir.glob(File.join(Config::BASE_PATH, "selling-partner-api-models/models/**/*.json"))
    end
  end
end
