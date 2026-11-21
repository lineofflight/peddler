# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchQueryPerformance
      # The search query performance click data.
      SearchQueryPerformanceClickData = Structure.new do
        # For a search query, the number of clicks for the current ASIN.
        attribute(:asin_click_count, Integer, null: false, from: "asinClickCount")

        # The fraction of clicks for the current ASIN in comparison to the total click count for the query.
        attribute(:asin_click_share, Float, null: false, from: "asinClickShare")

        attribute(:asin_median_click_price, Money, null: false, from: "asinMedianClickPrice")

        # For a search query, the number of ASIN clicks that originate from the search results page for any ASIN.
        attribute(:total_click_count, Integer, null: false, from: "totalClickCount")

        # For a search query, the number of clicks divided by the search query volume.
        attribute(:total_click_rate, Float, null: false, from: "totalClickRate")

        attribute(:total_median_click_price, Money, null: false, from: "totalMedianClickPrice")

        # The number of times customers click on any ASIN with the one-day delivery message from the search results page
        # for the specific query.
        attribute(:total_one_day_shipping_click_count, Integer, null: false, from: "totalOneDayShippingClickCount")

        # The number of times customers click on any ASIN with the same-day delivery message from the search results
        # page for the specific query.
        attribute(:total_same_day_shipping_click_count, Integer, null: false, from: "totalSameDayShippingClickCount")

        # The number of times customers click on any ASIN with the two-day delivery message from the search results page
        # for the specific query.
        attribute(:total_two_day_shipping_click_count, Integer, null: false, from: "totalTwoDayShippingClickCount")
      end
    end
  end
end
