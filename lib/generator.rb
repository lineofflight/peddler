# frozen_string_literal: true

require "fileutils"

require "generator/config"
require "generator/api"
require "generator/entrypoint"

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
      output_dir = File.join(Config::BASE_PATH, "lib/peddler/api")
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
      %x(rubocop --format simple --autocorrect #{File.join(Config::BASE_PATH, "lib")} 2>&1)
    end

    def apis
      api_model_files.map { |file| API.new(file) }.reject(&:obsolete?)
    end

    def api_model_files
      Dir.glob(File.join(Config::BASE_PATH, "selling-partner-api-models/models/**/*.json"))
    end
  end
end
