# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorSales
      # Describes aggregated ASIN-level sales metrics for ASINs in the vendor's account.
      SalesByASIN = Structure.new do
        # @return [String] The Amazon Standard Identification Number.
        attribute(:asin, String)

        # @return [Date] The end date of the aggregated ASIN-level data.
        attribute(:end_date, Date, from: "endDate")

        # @return [Money] Revenue based on the cost of goods sold. Adjustments are made for returns.
        attribute(:shipped_cogs, Money, from: "shippedCogs")

        # @return [Money] Revenue based on units shipped in the selected time frame. Adjustments are made for returns.
        attribute(:shipped_revenue, Money, from: "shippedRevenue")

        # @return [Integer] Number of units shipped to Amazon customers.
        attribute(:shipped_units, Integer, from: "shippedUnits")

        # @return [Date] The start date of the aggregated ASIN-level data.
        attribute(:start_date, Date, from: "startDate")

        # @return [Integer] The quantity of units returned. This field is populated when sellingProgram is RETAIL or
        #   BUSINESS.
        attribute?(:customer_returns, Integer, from: "customerReturns")

        # @return [Money] Ordered product sales in the selected time frame. Adjustments are made for returns. This field
        #   is populated when distributorView is MANUFACTURING
        attribute?(:ordered_revenue, Money, from: "orderedRevenue")

        # @return [Integer] Number of units ordered by Amazon customers. This field is populated when distributorView is
        #   MANUFACTURING
        attribute?(:ordered_units, Integer, from: "orderedUnits")
      end
    end
  end
end
