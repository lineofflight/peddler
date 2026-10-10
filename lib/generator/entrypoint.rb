# frozen_string_literal: true

require "erb"

require_relative "support/logger"
require_relative "api"
require_relative "support/config"
require_relative "support/file_writer"

module Generator
  class Entrypoint
    include FileWriter

    attr_reader :apis

    class << self
      def generate
        new(API.apis).generate
        Generator.logger.info("Generated entrypoint peddler")
      end
    end

    def initialize(apis)
      @apis = apis
    end

    def generate
      format_files([write_file(file_path, render_template)])
    end

    private

    def render_template
      ERB.new(template, trim_mode: "-").result(binding)
    end

    def file_path
      File.join(Config::BASE_PATH, "lib/peddler.rb")
    end

    def template
      File.read(Config.template_path("entrypoint"))
    end
  end
end
