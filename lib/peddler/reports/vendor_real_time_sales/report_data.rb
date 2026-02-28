# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorRealTimeSales
      # Contains details about hour and ASIN combinations for the specified time range.
      ReportData = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN).
        attribute(:asin, String, null: false)

        # @return [Time] The end of a date-time range in UTC representing the end of the hour for this object.
        attribute(:end_time, Time, null: false, from: "endTime")

        # @return [Float] Ordered Product Sales in the specified hour as of the time the report is generated.
        #   Adjustments are made for cancellations.
        attribute(:ordered_revenue, Float, null: false, from: "orderedRevenue")

        # @return [Integer] Number of units ordered by Amazon customers. This number can be negative if there are more
        #   cancellations than orders.
        attribute(:ordered_units, Integer, null: false, from: "orderedUnits")

        # @return [Time] The start of a date-time range in UTC representing the beginning of the hour for this object.
        attribute(:start_time, Time, null: false, from: "startTime")
      end
    end
  end
end
