# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Reports20210630
      # Detailed information about a report schedule.
      ReportSchedule = Structure.new do
        # @return [String] An {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} period value that
        #   indicates how often a report should be created.
        attribute(:period, String, null: false)

        # @return [String] The identifier for the report schedule. This identifier is unique only in combination with a
        #   seller ID.
        attribute(:report_schedule_id, String, null: false, from: "reportScheduleId")

        # @return [String] The report type. Refer to [Report Type
        #   Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
        attribute(:report_type, String, null: false, from: "reportType")

        # @return [Array<String>] A list of marketplace identifiers. The report document's contents will contain data
        #   for all of the specified marketplaces, unless the report type indicates otherwise.
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [Time] The date and time when the schedule will create its next report, in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} date time format.
        attribute?(:next_report_creation_time, Time, from: "nextReportCreationTime")

        # @return [Hash]
        attribute?(:report_options, Hash, from: "reportOptions")
      end
    end
  end
end
