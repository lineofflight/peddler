# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchQueryPerformance
      # The search query performance purchase data.
      SearchQueryPerformancePurchaseData = Structure.new do
        # @return [Money]
        attribute(:asin_median_purchase_price, Money, from: "asinMedianPurchasePrice")

        # @return [Integer] For a search query, the number of purchases for the current ASIN.
        attribute(:asin_purchase_count, Integer, from: "asinPurchaseCount")

        # @return [Float] The fraction of purchase actions for the ASIN in comparison to the total purchase count for
        #   the query.
        attribute(:asin_purchase_share, Float, from: "asinPurchaseShare")

        # @return [Money]
        attribute(:total_median_purchase_price, Money, from: "totalMedianPurchasePrice")

        # @return [Integer] The number of times customers purchase any ASIN with a one-day delivery message from the
        #   search results page for the specific query.
        attribute(:total_one_day_shipping_purchase_count, Integer, from: "totalOneDayShippingPurchaseCount")

        # @return [Integer] For a search query, the number of purchases that originate from the search result for any
        #   ASIN.
        attribute(:total_purchase_count, Integer, from: "totalPurchaseCount")

        # @return [Float] For a search query, the number of purchases divided by the search query volume.
        attribute(:total_purchase_rate, Float, from: "totalPurchaseRate")

        # @return [Integer] The number of times customers purchase any ASIN with the same-day delivery message from the
        #   search results page for the specific query.
        attribute(:total_same_day_shipping_purchase_count, Integer, from: "totalSameDayShippingPurchaseCount")

        # @return [Integer] The number of times customers purchase any ASIN with a two-day delivery message from the
        #   search results page for the specific query.
        attribute(:total_two_day_shipping_purchase_count, Integer, from: "totalTwoDayShippingPurchaseCount")
      end
    end
  end
end
