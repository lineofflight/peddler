# frozen_string_literal: true

require "erb"
require "generator/config"

module Generator
  module RBS
    class Entrypoint
      attr_reader :apis

      def initialize(apis)
        @apis = apis
      end

      def generate
        File.write(file_path, render_template)
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
          api_list.sort_by do |api|
            version = api.version
            if version.start_with?("v")
              [1, version]
            else
              [2, version]
            end
          end.last
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
