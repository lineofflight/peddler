# frozen_string_literal: true

require_relative "../config"
require_relative "../support/file_writer"

module Generator
  module RBS
    # Generates consolidated RBS signature files for types in notifications, reports, and feeds
    # (These don't have API operations, just type definitions)
    class Types
      include FileWriter

      def initialize(api_name, api_types)
        @api_name = api_name
        @api_types = api_types
      end

      def generate
        write_file(rbs_file_path, content)
      end

      def content
        lines = []
        lines << "# #{Config::GENERATED_FILE_NOTICE}"
        lines << ""
        lines << "module Peddler"

        # Determine if this is a notification, report, feed, or regular type
        is_notification = @api_name.start_with?("notifications/")
        is_report = @api_name.start_with?("reports/")
        is_feed = @api_name.start_with?("feeds/")

        if is_notification
          notification_name = @api_name.sub("notifications/", "").camelize
          lines << "  module Notifications"
          lines << "    module #{notification_name}"
        elsif is_report
          report_name = @api_name.sub("reports/", "").camelize
          lines << "  module Reports"
          lines << "    module #{report_name}"
        elsif is_feed
          feed_name = @api_name.sub("feeds/", "").camelize
          lines << "  module Feeds"
          lines << "    module #{feed_name}"
        else
          raise "RBS::Types should only be used for notifications, reports, or feeds. Got: #{@api_name}"
        end

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

        # For notifications, reports, and feeds, add module-level parse method
        if is_notification
          # Find the Notification type to get its fully qualified name
          notification_type = sorted_types.find { |t| t.class_name == "Notification" }
          if notification_type
            full_type_name = "Peddler::Notifications::#{notification_name}::Notification"
            lines << "      def self.parse: (Hash[String | Symbol, untyped]) -> #{full_type_name}"
            lines << ""
          end
        elsif is_report
          # Find the Report type to get its fully qualified name
          report_type = sorted_types.find { |t| t.class_name == "Report" }
          if report_type
            full_type_name = "Peddler::Reports::#{report_name}::Report"
            lines << "      def self.parse: (Hash[String | Symbol, untyped]) -> #{full_type_name}"
            lines << ""
          end
        elsif is_feed
          # Find the Feed type to get its fully qualified name
          feed_type = sorted_types.find { |t| t.class_name == "Feed" }
          if feed_type
            full_type_name = "Peddler::Feeds::#{feed_name}::Feed"
            lines << "      def self.parse: (Hash[String | Symbol, untyped]) -> #{full_type_name}"
            lines << ""
          end
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
        # Determine the right path based on whether this is a notification, report, or feed
        if @api_name.start_with?("notifications/")
          # For notifications, remove "notifications/" prefix and put in sig/peddler/notifications/
          notification_path = @api_name.sub("notifications/", "")
          File.join(Config::BASE_PATH, "sig/peddler/notifications/#{notification_path}.rbs")
        elsif @api_name.start_with?("reports/")
          # For reports, remove "reports/" prefix and put in sig/peddler/reports/
          report_path = @api_name.sub("reports/", "")
          File.join(Config::BASE_PATH, "sig/peddler/reports/#{report_path}.rbs")
        elsif @api_name.start_with?("feeds/")
          # For feeds, remove "feeds/" prefix and put in sig/peddler/feeds/
          feed_path = @api_name.sub("feeds/", "")
          File.join(Config::BASE_PATH, "sig/peddler/feeds/#{feed_path}.rbs")
        else
          raise "RBS::Types should only be used for notifications, reports, or feeds. Got: #{@api_name}"
        end
      end
    end
  end
end
