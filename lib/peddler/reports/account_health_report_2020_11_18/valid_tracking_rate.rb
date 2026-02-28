# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's valid tracking rate within a given reporting date range for 1 requested marketplace.
      ValidTrackingRate = Structure.new do
        # @return [String]
        attribute(:rate, String, null: false)

        # @return [ReportingDateRange]
        attribute(:reporting_date_range, ReportingDateRange, null: false, from: "reportingDateRange")

        # @return [Integer] The number of shipments within a given reporting date range for 1 requested marketplace.
        attribute(:shipment_count, Integer, null: false, from: "shipmentCount")

        # @return [String]
        attribute(:status, String, null: false)

        # @return [String]
        attribute(:target_condition, String, null: false, from: "targetCondition")

        # @return [String]
        attribute(:target_value, String, null: false, from: "targetValue")

        # @return [Integer] Shipment with valid tracking count within a given reporting date range for 1 requested
        #   marketplace.
        attribute(:valid_tracking_count, Integer, null: false, from: "validTrackingCount")
      end
    end
  end
end
