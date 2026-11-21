# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's late shipment rate within a given reporting date range for 1 requested marketplace.
      LateShipmentRate = Structure.new do
        # Order defects count due to late shipment.
        attribute(:late_shipment_count, Integer, null: false, from: "lateShipmentCount")

        attribute(:order_count, String, null: false, from: "orderCount")

        attribute(:rate, String, null: false)

        attribute(:reporting_date_range, ReportingDateRange, null: false, from: "reportingDateRange")

        attribute(:status, String, null: false)

        attribute(:target_condition, String, null: false, from: "targetCondition")

        attribute(:target_value, String, null: false, from: "targetValue")
      end
    end
  end
end
