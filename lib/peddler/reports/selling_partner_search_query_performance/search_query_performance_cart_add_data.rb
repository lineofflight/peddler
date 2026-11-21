# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchQueryPerformance
      # The search query performance cart add data.
      SearchQueryPerformanceCartAddData = Structure.new do
        # For a search query, the number of cart-adds for the ASIN that originates from the search results page.
        attribute(:asin_cart_add_count, Integer, null: false, from: "asinCartAddCount")

        # The fraction of cart-adds for the ASIN in comparison to the total cart-add count for the query.
        attribute(:asin_cart_add_share, Float, null: false, from: "asinCartAddShare")

        attribute(:asin_median_cart_add_price, Money, null: false, from: "asinMedianCartAddPrice")

        # For a search query, the number of cart-adds that originate from the search result page across all ASINs.
        attribute(:total_cart_add_count, Integer, null: false, from: "totalCartAddCount")

        # For a search query, the number of cart-adds across all ASINs divided by the search query volume.
        attribute(:total_cart_add_rate, Float, null: false, from: "totalCartAddRate")

        attribute(:total_median_cart_add_price, Money, null: false, from: "totalMedianCartAddPrice")

        # The number of times customers add any ASIN with the one-day delivery message to a cart from the search results
        # page for the specific query.
        attribute(:total_one_day_shipping_cart_add_count, Integer, null: false, from: "totalOneDayShippingCartAddCount")

        # The number of times customers add any ASIN with the same-day delivery message to a cart from the search
        # results page for the specific query.
        attribute(:total_same_day_shipping_cart_add_count, Integer, null: false, from: "totalSameDayShippingCartAddCount")

        # The number of times customers add any ASIN with the two-day delivery message to a cart from the search results
        # page for the specific query.
        attribute(:total_two_day_shipping_cart_add_count, Integer, null: false, from: "totalTwoDayShippingCartAddCount")
      end
    end
  end
end
