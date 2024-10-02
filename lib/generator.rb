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
      FileUtils.rm_rf(Config::OUTPUT_DIR)
      FileUtils.mkdir_p(Config::OUTPUT_DIR)
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
      @apis ||= Config.api_model_files.map { |file| API.new(file) }.reject(&:obsolete?)
    end
  end
end
