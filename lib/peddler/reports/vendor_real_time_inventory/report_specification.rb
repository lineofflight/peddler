# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorRealTimeInventory
      # Summarizes the original report request.
      ReportSpecification = Structure.new do
        # @return [Time] The end of a date-time range in UTC used to determine hours to report on. Output will include
        #   all full hours that fall within the range. End time should not be more than 24 hours from the start time.
        attribute(:data_end_time, Time, null: false, from: "dataEndTime")

        # @return [Time] The start of a date-time range in UTC used to determine hours to report on. Output will include
        #   all full hours that fall within the range. Start time can be up to 168 hours before the time of the request.
        attribute(:data_start_time, Time, null: false, from: "dataStartTime")

        # @return [Array<String>] Marketplace IDs as specified in the report request.
        attribute(:marketplace_ids, [String], null: false, from: "marketplaceIds")

        # @return [String] The report type.
        attribute(:report_type, String, null: false, from: "reportType")
      end
    end
  end
end
