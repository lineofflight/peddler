# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's pre-fulfillment cancellation rate within a given reporting date range for 1 requested marketplace.
      PreFulfillmentCancellationRate = Structure.new do
        # @return [Integer] The number of seller faulted cancelled orders within a given reporting date range for 1
        #   requested marketplace.
        attribute(:cancellation_count, Integer, null: false, from: "cancellationCount")

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
