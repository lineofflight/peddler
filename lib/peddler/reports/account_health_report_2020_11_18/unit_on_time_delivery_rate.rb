# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # The seller's on-time delivery rate at a unit level within a reporting date range for one marketplace that you
      # specify. This metric is only available in the US marketplace.
      UnitOnTimeDeliveryRate = Structure.new do
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

        # @return [Integer] The total unit count within a reporting date range for one marketplace that you specify.
        attribute(:total_unit_count, Integer, null: false, from: "totalUnitCount")

        # @return [Integer] The on-time delivery unit count within a reporting date range for one marketplace that you
        #   specify.
        attribute(:unit_on_time_delivery_count, Integer, null: false, from: "unitOnTimeDeliveryCount")
      end
    end
  end
end
