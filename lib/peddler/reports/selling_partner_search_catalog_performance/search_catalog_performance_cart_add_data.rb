# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchCatalogPerformance
      # The search attributed cart-add data for your catalog.
      SearchCatalogPerformanceCartAddData = Structure.new do
        # @return [Integer] The number of times customers add an ASIN to a cart. This data originates from the search
        #   results page.
        attribute(:cart_add_count, Integer, from: "cartAddCount")

        # @return [Money]
        attribute(:cart_added_median_price, Money, from: "cartAddedMedianPrice")

        # @return [Integer] The number of times customers add an ASIN to a cart with the one-day delivery message in the
        #   search results page.
        attribute(:one_day_shipping_cart_add_count, Integer, from: "oneDayShippingCartAddCount")

        # @return [Integer] The number of times customers add an ASIN to a cart with the same day delivery message in
        #   the search results page.
        attribute(:same_day_shipping_cart_add_count, Integer, from: "sameDayShippingCartAddCount")

        # @return [Integer] The number of times customers add an ASIN to a cart with the two-day delivery message in the
        #   search results page.
        attribute(:two_day_shipping_cart_add_count, Integer, from: "twoDayShippingCartAddCount")
      end
    end
  end
end
