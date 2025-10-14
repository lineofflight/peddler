# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's on-time delivery rate within a given reporting date range for 1 requested marketplace.
      OnTimeDeliveryRate = Structure.new do
        # @return [Integer] On-time delivered shipment count within a given reporting date range for 1 requested
        # marketplace.
        attribute(:on_time_delivery_count, Integer, from: "onTimeDeliveryCount")

        # @return [String]
        attribute(:rate, String)

        # @return [ReportingDateRange]
        attribute(:reporting_date_range, ReportingDateRange, from: "reportingDateRange")

        # @return [Float] The number of shipments with valid tracking associated within a given reporting date range for
        # 1 requested marketplace.
        attribute(:shipment_count_with_valid_tracking, Float, from: "shipmentCountWithValidTracking")

        # @return [String]
        attribute(:status, String)

        # @return [String]
        attribute(:target_condition, String, from: "targetCondition")

        # @return [String]
        attribute(:target_value, String, from: "targetValue")
      end
    end
  end
end
