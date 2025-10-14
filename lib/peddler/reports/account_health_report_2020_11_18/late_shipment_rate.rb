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
        attribute(:late_shipment_count, Integer, from: "lateShipmentCount")

        # @return [String]
        attribute(:order_count, String, from: "orderCount")

        # @return [String]
        attribute(:rate, String)

        # @return [ReportingDateRange]
        attribute(:reporting_date_range, ReportingDateRange, from: "reportingDateRange")

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
