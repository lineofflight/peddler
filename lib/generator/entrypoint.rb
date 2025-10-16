# frozen_string_literal: true

require "erb"

require_relative "support/logger"
require_relative "api"
require_relative "support/config"
require_relative "support/file_writer"
require_relative "resolvers/version_selector"
require_relative "rbs/entrypoint"

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
      written_files = []

      # Generate main entrypoint file
      written_files << write_file(file_path, render_template)

      # Generate entrypoint signature
      written_files << RBS::Entrypoint.new(apis).generate

      format_files(written_files)
    end

    def required_libraries
      apis.map(&:library_name).append("peddler/lwa").sort
    end

    def apis_with_latest_version
      apis.group_by(&:name).transform_values do |api_list|
        latest_version = VersionSelector.find_latest_version(api_list.map(&:version))
        api_list.find { |api| api.version == latest_version }
      end.sort.to_h
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
