# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # The search click data for your catalog.
      SearchCatalogPerformanceClickData = Structure.new do
        # The total number of clicks on the ASIN that originates from the search results page.
        attribute(:click_count, Integer, null: false, from: "clickCount")

        # The number of clicks divided by the number of impressions for the ASIN.
        attribute(:click_rate, Float, null: false, from: "clickRate")

        attribute(:clicked_median_price, Money, null: false, from: "clickedMedianPrice")

        # The number of times customers click on the ASIN with the one-day delivery message on the search results page.
        attribute(:one_day_shipping_click_count, Integer, null: false, from: "oneDayShippingClickCount")

        # The number of times customers click on the ASIN with the same day delivery message on the search results page.
        attribute(:same_day_shipping_click_count, Integer, null: false, from: "sameDayShippingClickCount")

        # The number of times customers click on the ASIN with the two-day delivery message on the search results page.
        attribute(:two_day_shipping_click_count, Integer, null: false, from: "twoDayShippingClickCount")
      end
    end
  end
end
