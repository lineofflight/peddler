# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # The SellerAnalyticsView retrieves aggregated cross-domain seller analytics data based on specified
      # GroupByAttributes for the seller's account.
      SellerAnalyticsView = Structure.new do
        # @return [String] End date of the time period.
        attribute?(:end_date, String, null: false, from: "endDate")

        # @return [Array<SellerAnalyticsViewGroupedBy>] Metrics for the given time period, grouped by, for example,
        #   ASIN/SKU.
        attribute?(:metrics, [SellerAnalyticsViewGroupedBy], null: false)

        # @return [SellerAttributes] Seller Attributes for the account. These are static attributes that don't change
        #   per metric or groupBy.
        attribute?(:seller_attributes, SellerAttributes, from: "sellerAttributes")

        # @return [String] Start date of the time period.
        attribute?(:start_date, String, null: false, from: "startDate")

        # @return [SellerAnalyticsViewMetrics] Totals (aggregate across all of the seller catalog) for the given time
        #   period.
        attribute?(:totals, SellerAnalyticsViewMetrics, null: false)
      end
    end
  end
end
