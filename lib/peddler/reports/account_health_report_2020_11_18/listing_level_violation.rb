# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's listing level violation metric within a given reporting date range for 1 requested marketplace.
      ListingLevelViolation = Structure.new do
        attribute(:defects_count, String, null: false, from: "defectsCount")

        attribute(:reporting_date_range, ReportingDateRange, null: false, from: "reportingDateRange")

        attribute(:status, String, null: false)

        attribute(:target_condition, String, null: false, from: "targetCondition")

        attribute(:target_value, String, null: false, from: "targetValue")
      end
    end
  end
end
