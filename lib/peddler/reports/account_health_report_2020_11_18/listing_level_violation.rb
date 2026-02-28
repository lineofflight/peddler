# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's listing level violation metric within a given reporting date range for 1 requested marketplace.
      ListingLevelViolation = Structure.new do
        # @return [String]
        attribute(:defects_count, String, null: false, from: "defectsCount")

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
