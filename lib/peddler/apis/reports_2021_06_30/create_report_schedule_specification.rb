# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Reports20210630
      # Information required to create the report schedule.
      CreateReportScheduleSpecification = Structure.new do
        # @return [Array<String>] A list of marketplace identifiers for the report schedule.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [String] One of a set of predefined {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601}
        #   periods that specifies how often a report should be created.
        attribute(:period, String)

        # @return [String] The report type. Refer to [Report Type
        #   Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
        attribute(:report_type, String, from: "reportType")

        # @return [Time] The date and time when the schedule will create its next report, in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} date time format.
        attribute?(:next_report_creation_time, Time, from: "nextReportCreationTime")

        # @return [Hash]
        attribute?(:report_options, Hash, from: "reportOptions")
      end
    end
  end
end
