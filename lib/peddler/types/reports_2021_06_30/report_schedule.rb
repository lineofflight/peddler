# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/reports_2021_06_30/report_options"

module Peddler
  module Types
    module Reports20210630
      # Detailed information about a report schedule.
      ReportSchedule = Structure.new do
        # @return [String] The identifier for the report schedule. This identifier is unique only in combination with a
        # seller ID.
        attribute(:report_schedule_id, String, from: "reportScheduleId")

        # @return [String] The report type. Refer to [Report Type
        # Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
        attribute(:report_type, String, from: "reportType")

        # @return [Array<String>] A list of marketplace identifiers. The report document's contents will contain data
        # for all of the specified marketplaces, unless the report type indicates otherwise.
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [ReportOptions]
        attribute?(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] An {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} period value that
        # indicates how often a report should be created.
        attribute(:period, String)

        # @return [String] The date and time when the schedule will create its next report, in
        # {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} date time format.
        attribute?(:next_report_creation_time, String, from: "nextReportCreationTime")
      end
    end
  end
end
