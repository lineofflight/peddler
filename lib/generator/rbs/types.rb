# frozen_string_literal: true

require_relative "../support/config"
require_relative "../support/file_writer"

module Generator
  module RBS
    # Generates consolidated RBS signature files for types in notifications, reports, and feeds
    # (These don't have API operations, just type definitions)
    class Types
      include FileWriter

      KIND_DEFS = [
        ["notifications/", "Notifications", "sig/peddler/notifications", :notification],
        ["reports/", "Reports", "sig/peddler/reports", :report],
        ["feeds/", "Feeds", "sig/peddler/feeds", :feed],
        ["data_kiosk/", "DataKiosk", "sig/peddler/data_kiosk", :data_kiosk],
      ].freeze

      def initialize(api_name, api_types)
        @api_name = api_name
        @api_types = api_types
      end

      def generate
        write_file(rbs_file_path, content)
      end

      def content
        context = api_context
        lines = []
        lines << "# #{Config::GENERATED_FILE_NOTICE}"
        lines << ""
        lines << "module Peddler"
        lines << "  module #{context[:module_name]}"
        lines << "    module #{context[:name]}"

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

        # For notifications, reports, feeds, and data_kiosk, add module-level parse method
        case context[:kind]
        when :notification
          notification_type = sorted_types.find { |t| t.class_name == "Notification" }
          if notification_type
            full_type_name = "Peddler::#{context[:module_name]}::#{context[:name]}::Notification"
            lines << "      def self.parse: (Hash[String | Symbol, untyped]) -> #{full_type_name}"
            lines << ""
          end
        when :report
          report_type = sorted_types.find { |t| t.class_name == "Report" }
          if report_type
            full_type_name = "Peddler::#{context[:module_name]}::#{context[:name]}::Report"
            lines << "      def self.parse: (Hash[String | Symbol, untyped]) -> #{full_type_name}"
            lines << ""
          end
        when :feed
          feed_type = sorted_types.find { |t| t.class_name == "Feed" }
          if feed_type
            full_type_name = "Peddler::#{context[:module_name]}::#{context[:name]}::Feed"
            lines << "      def self.parse: (Hash[String | Symbol, untyped]) -> #{full_type_name}"
            lines << ""
          end
        when :data_kiosk
          lines << "      def self.schema: () -> Hash[String, untyped]"
          lines << ""
        end

        # Remove trailing blank line
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
        context = api_context
        File.join(Config::BASE_PATH, "#{context[:sig_dir]}/#{context[:short]}.rbs")
      end

      def api_context
        @api_context ||= begin
          match = KIND_DEFS.find { |prefix, _module_name, _sig_dir, _kind| @api_name.start_with?(prefix) }
          raise "RBS::Types should only be used for notifications, reports, feeds, or data_kiosk. Got: #{@api_name}" unless match

          prefix, module_name, sig_dir, kind = match
          short = @api_name.delete_prefix(prefix)

          {
            module_name: module_name,
            sig_dir: sig_dir,
            kind: kind,
            name: short.camelize,
            short: short,
          }
        end
      end
    end
  end
end
