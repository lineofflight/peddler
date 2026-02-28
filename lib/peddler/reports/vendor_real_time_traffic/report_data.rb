# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorRealTimeTraffic
      # Contains details about hour and ASIN combinations for the specified time range.
      ReportData = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN).
        attribute(:asin, String, null: false)

        # @return [Time] The end of a date-time range in UTC representing the end of the hour for this object.
        attribute(:end_time, Time, null: false, from: "endTime")

        # @return [Integer] The number of customer views of the product detail page for this ASIN.
        attribute(:glance_views, Integer, null: false, from: "glanceViews")

        # @return [Time] The start of a date-time range in UTC representing the beginning of the hour for this object.
        attribute(:start_time, Time, null: false, from: "startTime")
      end
    end
  end
end
