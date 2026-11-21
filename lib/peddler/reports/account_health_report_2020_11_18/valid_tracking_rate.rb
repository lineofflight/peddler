# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's valid tracking rate within a given reporting date range for 1 requested marketplace.
      ValidTrackingRate = Structure.new do
        attribute(:rate, String, null: false)

        attribute(:reporting_date_range, ReportingDateRange, null: false, from: "reportingDateRange")

        # The number of shipments within a given reporting date range for 1 requested marketplace.
        attribute(:shipment_count, Integer, null: false, from: "shipmentCount")

        attribute(:status, String, null: false)

        attribute(:target_condition, String, null: false, from: "targetCondition")

        attribute(:target_value, String, null: false, from: "targetValue")

        # Shipment with valid tracking count within a given reporting date range for 1 requested marketplace.
        attribute(:valid_tracking_count, Integer, null: false, from: "validTrackingCount")
      end
    end
  end
end
