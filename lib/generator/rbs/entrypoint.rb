# frozen_string_literal: true

require "erb"
require_relative "../support/config"
require_relative "../support/file_writer"
require_relative "../resolvers/version_selector"

module Generator
  module RBS
    class Entrypoint
      include FileWriter

      attr_reader :apis

      def initialize(apis)
        @apis = apis
      end

      def generate
        write_file(file_path, render_template)
      end

      def api_methods
        apis.map do |api|
          {
            name: api.name_with_version,
            class_name: api.class_name,
          }
        end.sort_by { |api| api[:name] }
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
        File.join(Config::BASE_PATH, "sig/peddler.rbs")
      end

      def template
        File.read(Config.template_path("rbs/entrypoint"))
      end
    end
  end
end
