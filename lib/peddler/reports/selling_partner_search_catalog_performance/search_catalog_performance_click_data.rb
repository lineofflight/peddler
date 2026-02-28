# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # The search click data for your catalog.
      SearchCatalogPerformanceClickData = Structure.new do
        # @return [Integer] The total number of clicks on the ASIN that originates from the search results page.
        attribute(:click_count, Integer, null: false, from: "clickCount")

        # @return [Float] The number of clicks divided by the number of impressions for the ASIN.
        attribute(:click_rate, Float, null: false, from: "clickRate")

        # @return [Money]
        attribute(:clicked_median_price, Money, null: false, from: "clickedMedianPrice")

        # @return [Integer] The number of times customers click on the ASIN with the one-day delivery message on the
        #   search results page.
        attribute(:one_day_shipping_click_count, Integer, null: false, from: "oneDayShippingClickCount")

        # @return [Integer] The number of times customers click on the ASIN with the same day delivery message on the
        #   search results page.
        attribute(:same_day_shipping_click_count, Integer, null: false, from: "sameDayShippingClickCount")

        # @return [Integer] The number of times customers click on the ASIN with the two-day delivery message on the
        #   search results page.
        attribute(:two_day_shipping_click_count, Integer, null: false, from: "twoDayShippingClickCount")
      end
    end
  end
end
