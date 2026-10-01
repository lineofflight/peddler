# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Common price and count metrics shared by query and catalog search metrics.
      # Groups impressions, clicks, cart adds, and purchases with their associated prices.
      PriceAndCountMetrics = Structure.new do
        # @return [UnitsWithValueAndBenchmarking] Number of times added to cart from search results, with price at time
        #   of add.
        attribute?(:cart_adds_with_price, UnitsWithValueAndBenchmarking, from: "cartAddsWithPrice")

        # @return [UnitsWithValueAndBenchmarking] Number of clicks from search results, with price at time of click.
        attribute?(:clicks_with_price, UnitsWithValueAndBenchmarking, from: "clicksWithPrice")

        # @return [UnitsWithValueAndBenchmarking] Number of times the product appeared in search results, with price at
        #   time of impression.
        attribute?(:impressions_with_price, UnitsWithValueAndBenchmarking, from: "impressionsWithPrice")

        # @return [CountMetrics] Search performance metrics for products with one-day delivery option available.
        attribute?(:one_day_metrics, CountMetrics, from: "oneDayMetrics")

        # @return [UnitsWithValueAndBenchmarking] Number of purchases from search results, with price at time of
        #   purchase.
        attribute?(:purchases_with_price, UnitsWithValueAndBenchmarking, from: "purchasesWithPrice")

        # @return [CountMetrics] Search performance metrics for products with same-day delivery option available.
        attribute?(:same_day_metrics, CountMetrics, from: "sameDayMetrics")

        # @return [CountMetrics] Search performance metrics for products with two-day delivery option available.
        attribute?(:two_day_metrics, CountMetrics, from: "twoDayMetrics")
      end
    end
  end
end
