# frozen_string_literal: true

require "generator/config"

module Generator
  module RBS
    # Generates consolidated RBS signature files for types, grouping all types for an API into a single file
    class Types
      def initialize(api_name, api_types)
        @api_name = api_name
        @api_types = api_types
      end

      def generate
        lines = [] #: Array[String]
        lines << "# #{Config::GENERATED_FILE_NOTICE}"
        lines << ""
        lines << "module Peddler"
        lines << "  module Types"
        lines << "    module #{@api_name.camelize}"

        # Sort types alphabetically by class name for consistent output
        sorted_types = @api_types.sort_by(&:class_name)

        # Generate each type's class definition
        sorted_types.each do |type|
          class_def = type.rbs_class_definition
          # Indent the class definition with 6 spaces (3 levels of nesting)
          indented_class = indent(class_def, 6)
          lines << indented_class
          lines << "" # Add blank line between classes
        end

        # Remove trailing blank line
        lines.pop if lines.last == ""

        lines << "    end"
        lines << "  end"
        lines << "end"

        write_file(lines.join("\n") + "\n")
      end

      private

      def indent(text, spaces)
        prefix = " " * spaces
        text.lines.map { |line| line.strip.empty? ? line : "#{prefix}#{line}" }.join
      end

      def write_file(content)
        file_path = File.join(Config::BASE_PATH, "sig/peddler/types/#{@api_name}.rbs")
        FileUtils.mkdir_p(File.dirname(file_path))
        File.write(file_path, content)
      end
    end
  end
end
