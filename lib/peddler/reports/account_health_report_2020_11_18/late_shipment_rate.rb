# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's late shipment rate within a given reporting date range for 1 requested marketplace.
      LateShipmentRate = Structure.new do
        # @return [Integer] Order defects count due to late shipment.
        attribute(:late_shipment_count, Integer, null: false, from: "lateShipmentCount")

        # @return [String]
        attribute(:order_count, String, null: false, from: "orderCount")

        # @return [String]
        attribute(:rate, String, null: false)

        # @return [ReportingDateRange]
        attribute(:reporting_date_range, ReportingDateRange, null: false, from: "reportingDateRange")

        # @return [String]
        attribute(:status, String, null: false)

        # @return [String]
        attribute(:target_condition, String, null: false, from: "targetCondition")

        # @return [String]
        attribute(:target_value, String, null: false, from: "targetValue")
      end
    end
  end
end
