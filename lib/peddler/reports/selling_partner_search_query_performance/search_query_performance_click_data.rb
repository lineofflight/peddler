# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchQueryPerformance
      # The search query performance click data.
      SearchQueryPerformanceClickData = Structure.new do
        # @return [Integer] For a search query, the number of clicks for the current ASIN.
        attribute(:asin_click_count, Integer, from: "asinClickCount")

        # @return [Float] The fraction of clicks for the current ASIN in comparison to the total click count for the
        # query.
        attribute(:asin_click_share, Float, from: "asinClickShare")

        # @return [Money]
        attribute(:asin_median_click_price, Money, from: "asinMedianClickPrice")

        # @return [Integer] For a search query, the number of ASIN clicks that originate from the search results page
        # for any ASIN.
        attribute(:total_click_count, Integer, from: "totalClickCount")

        # @return [Float] For a search query, the number of clicks divided by the search query volume.
        attribute(:total_click_rate, Float, from: "totalClickRate")

        # @return [Money]
        attribute(:total_median_click_price, Money, from: "totalMedianClickPrice")

        # @return [Integer] The number of times customers click on any ASIN with the one-day delivery message from the
        # search results page for the specific query.
        attribute(:total_one_day_shipping_click_count, Integer, from: "totalOneDayShippingClickCount")

        # @return [Integer] The number of times customers click on any ASIN with the same-day delivery message from the
        # search results page for the specific query.
        attribute(:total_same_day_shipping_click_count, Integer, from: "totalSameDayShippingClickCount")

        # @return [Integer] The number of times customers click on any ASIN with the two-day delivery message from the
        # search results page for the specific query.
        attribute(:total_two_day_shipping_click_count, Integer, from: "totalTwoDayShippingClickCount")
      end
    end
  end
end
