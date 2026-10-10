# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorSales
      # Describes aggregated sales metrics for ASINs in the vendor's account.
      SalesAggregate = Structure.new do
        # The end date of the aggregated data.
        attribute(:end_date, Date, null: false, from: "endDate")

        # Revenue based on the cost of goods sold. Adjustments are made for returns.
        attribute(:shipped_cogs, Money, null: false, from: "shippedCogs")

        # Revenue based on units shipped in the selected time frame. Adjustments are made for returns.
        attribute(:shipped_revenue, Money, null: false, from: "shippedRevenue")

        # Number of units shipped to Amazon customers.
        attribute(:shipped_units, Integer, null: false, from: "shippedUnits")

        # The start date of the aggregated data.
        attribute(:start_date, Date, null: false, from: "startDate")

        # The quantity of units returned. This field is populated when sellingProgram is RETAIL or BUSINESS.
        attribute?(:customer_returns, Integer, from: "customerReturns")

        # Ordered product sales in the selected time frame. Adjustments are made for returns. This field is populated
        # when distributorView is MANUFACTURING.
        attribute?(:ordered_revenue, Money, from: "orderedRevenue")

        # Number of units ordered by Amazon customers. This field is populated when distributorView is MANUFACTURING.
        attribute?(:ordered_units, Integer, from: "orderedUnits")
      end
    end
  end
end
