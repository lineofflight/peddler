# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/reports_2021_06_30/report_options"

module Peddler
  module Types
    module Reports20210630
      # Information required to create the report schedule.
      CreateReportScheduleSpecification = Structure.new do
        # @return [String] The report type. Refer to [Report Type
        # Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
        attribute(:report_type, String, from: "reportType")

        # @return [Array<String>] A list of marketplace identifiers for the report schedule.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [ReportOptions]
        attribute?(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] One of a set of predefined <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> periods that specifies how often a
        # report should be created.
        attribute(:period, String)

        # @return [String] The date and time when the schedule will create its next report, in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> date time format.
        attribute?(:next_report_creation_time, String, from: "nextReportCreationTime")
      end
    end
  end
end
