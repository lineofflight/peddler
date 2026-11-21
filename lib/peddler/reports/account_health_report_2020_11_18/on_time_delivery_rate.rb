# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's on-time delivery rate within a given reporting date range for 1 requested marketplace.
      OnTimeDeliveryRate = Structure.new do
        # On-time delivered shipment count within a given reporting date range for 1 requested marketplace.
        attribute(:on_time_delivery_count, Integer, null: false, from: "onTimeDeliveryCount")

        attribute(:rate, String, null: false)

        attribute(:reporting_date_range, ReportingDateRange, null: false, from: "reportingDateRange")

        # The number of shipments with valid tracking associated within a given reporting date range for 1 requested
        # marketplace.
        attribute(:shipment_count_with_valid_tracking, Float, null: false, from: "shipmentCountWithValidTracking")

        attribute(:status, String, null: false)

        attribute(:target_condition, String, null: false, from: "targetCondition")

        attribute(:target_value, String, null: false, from: "targetValue")
      end
    end
  end
end
