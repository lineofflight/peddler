# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorRealTimeSales
      # Summarizes the original report request.
      ReportSpecification = Structure.new do
        # The end of a date-time range in UTC used to determine hours to report on. Output will include all full hours
        # that fall within the range.
        attribute(:data_end_time, Time, null: false, from: "dataEndTime")

        # The start of a date-time range in UTC used to determine hours to report on. Output will include all full hours
        # that fall within the range.
        attribute(:data_start_time, Time, null: false, from: "dataStartTime")

        # Marketplace IDs as specified in the report request.
        attribute(:marketplace_ids, [String], null: false, from: "marketplaceIds")

        # Report options specifying parameters such as currencyCode.
        attribute(:report_options, ReportOptions, null: false, from: "reportOptions")

        # The type of the report. Known values: `GET_VENDOR_REAL_TIME_SALES_REPORT`.
        attribute(:report_type, String, null: false, from: "reportType")
      end
    end
  end
end
