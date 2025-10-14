# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorRealTimeSales
      # Summarizes the original report request.
      ReportSpecification = Structure.new do
        # @return [Time] The end of a date-time range in UTC used to determine hours to report on. Output will include
        # all full hours that fall within the range.
        attribute(:data_end_time, Time, from: "dataEndTime")

        # @return [Time] The start of a date-time range in UTC used to determine hours to report on. Output will include
        # all full hours that fall within the range.
        attribute(:data_start_time, Time, from: "dataStartTime")

        # @return [Array<String>] Marketplace IDs as specified in the report request.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [ReportOptions] Report options specifying parameters such as currencyCode.
        attribute(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] The type of the report.
        attribute(:report_type, String, from: "reportType")
      end
    end
  end
end
