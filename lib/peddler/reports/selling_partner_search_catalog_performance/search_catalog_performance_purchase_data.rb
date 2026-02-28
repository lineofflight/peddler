# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # The search attributed purchase data for your catalog.
      SearchCatalogPerformancePurchaseData = Structure.new do
        # @return [Float] The number of purchases divided by the number of clicks for the ASIN.
        attribute(:conversion_rate, Float, null: false, from: "conversionRate")

        # @return [Integer] The number of times customers purchase an ASIN with the one-day delivery message in the
        #   search results page.
        attribute(:one_day_shipping_purchase_count, Integer, null: false, from: "oneDayShippingPurchaseCount")

        # @return [Integer] The total number of purchases for an ASIN. This data originates from the search results
        #   page.
        attribute(:purchase_count, Integer, null: false, from: "purchaseCount")

        # @return [Money]
        attribute(:purchase_median_price, Money, null: false, from: "purchaseMedianPrice")

        # @return [Integer] The number of times customers purchase an ASIN with the same day delivery message in the
        #   search results page.
        attribute(:same_day_shipping_purchase_count, Integer, null: false, from: "sameDayShippingPurchaseCount")

        # @return [Money]
        attribute(:search_traffic_sales, Money, null: false, from: "searchTrafficSales")

        # @return [Integer] The number of times customers purchase an ASIN with the two-day delivery message in the
        #   search results page.
        attribute(:two_day_shipping_purchase_count, Integer, null: false, from: "twoDayShippingPurchaseCount")
      end
    end
  end
end
