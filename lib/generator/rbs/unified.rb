# frozen_string_literal: true

require "erb"
require_relative "../support/config"
require_relative "../support/formatter"
require_relative "../support/file_writer"

module Generator
  module RBS
    # Generates one RBS file per API with its parser lookup and type definitions
    class Unified
      include Formatter
      include FileWriter

      attr_reader :api, :api_name, :api_types

      def initialize(api, api_name, api_types)
        @api = api
        @api_name = api_name
        @api_types = api_types
      end

      def generate
        write_file(rbs_file_path, content)
      end

      def class_name
        api.class_name
      end

      def content
        lines = []
        lines << "# #{Config::GENERATED_FILE_NOTICE}"
        lines << ""
        lines << "module Peddler"
        lines << "  module APIs"
        lines << "    module #{class_name}"
        lines << "      PARSERS: Hash[String, ^() -> untyped]"
        lines << ""

        sorted_types = api_types.sort_by(&:class_name)
        sorted_types.each do |type|
          class_def = type.rbs_class_definition
          # Indent the class definition with 6 spaces (inside the API module)
          indented_class = indent(class_def, 6)
          lines << indented_class
          lines << "" # Add blank line between classes
        end

        # Remove trailing blank line if present
        lines.pop if lines.last == ""

        lines << "    end"
        lines << "  end"
        lines << "end"

        lines.join("\n") + "\n"
      end

      private

      def indent(text, spaces)
        prefix = " " * spaces
        text.lines.map { |line| line.strip.empty? ? line : "#{prefix}#{line}" }.join
      end

      def rbs_file_path
        File.join(Config::BASE_PATH, "sig/peddler/apis/#{api_name}.rbs")
      end
    end
  end
end
