# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorTraffic
      # The report summary including the specified reporting date range and the last updated date in the input.
      ReportSpecification = Structure.new do
        # @return [Date] Determines the end date of the report - the time component is ignored. For WEEK, MONTH,
        # QUARTER, and YEAR reportPeriods, this value must correspond to the last day in the specified reportPeriod or
        # else a fatal error is returned. For example, dataEndTime must be a Saturday for the WEEK reportPeriod.
        attribute(:data_end_time, Date, from: "dataEndTime")

        # @return [Date] Determines the start date of the report - the time component is ignored. For WEEK, MONTH,
        # QUARTER, and YEAR reportPeriods, this value must correspond to the first day in the specified reportPeriod or
        # else a fatal error is returned. For example, dataStartTime must be a Sunday for the WEEK reportPeriod.
        attribute(:data_start_time, Date, from: "dataStartTime")

        # @return [Date] The date when the report was last updated. Follows the
        # {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} date format of YYYY-MM-DD.
        attribute(:last_updated_date, Date, from: "lastUpdatedDate")

        # @return [Array<String>] This parameter must match the marketplaceId of the selling partner account (each
        # selling partner account belongs to one and only one marketplaceId).
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [ReportOptions] Report options specifying parameters such as reportPeriod.
        attribute(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] The type of report.
        attribute(:report_type, String, from: "reportType")
      end
    end
  end
end
