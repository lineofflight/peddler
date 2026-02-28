# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # The search impression data for your catalog.
      SearchCatalogPerformanceImpressionData = Structure.new do
        # @return [Integer] Total number of impressions for the given ASIN, which originates from the search results
        #   page across all search queries. Amazon counts an impression every time the ASIN displays in the search
        #   results page. Impressions include sponsored search results.
        attribute(:impression_count, Integer, null: false, from: "impressionCount")

        # @return [Money]
        attribute(:impression_median_price, Money, null: false, from: "impressionMedianPrice")

        # @return [Integer] The number of times the impressed ASIN displays with the one-day delivery message in a
        #   search results page.
        attribute(:one_day_shipping_impression_count, Integer, null: false, from: "oneDayShippingImpressionCount")

        # @return [Integer] The number of times the impressed ASIN displays with the same day delivery message in a
        #   search results page.
        attribute(:same_day_shipping_impression_count, Integer, null: false, from: "sameDayShippingImpressionCount")

        # @return [Integer] The number of times the impressed ASIN displays with the two-day delivery message in a
        #   search results page.
        attribute(:two_day_shipping_impression_count, Integer, null: false, from: "twoDayShippingImpressionCount")
      end
    end
  end
end
