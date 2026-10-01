# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Search metrics at the catalog/ASIN level, aggregated across all keywords.
      SearchCatalogMetrics = Structure.new do
        # @return [FloatWithBenchmarking] Percentage of impressions that resulted in a click.
        attribute?(:click_rate, FloatWithBenchmarking, from: "clickRate")

        # @return [FloatWithBenchmarking] Percentage of impressions that resulted in a purchase.
        attribute?(:conversion_rate, FloatWithBenchmarking, from: "conversionRate")

        # @return [PriceAndCountMetrics] Core search metrics including impressions, clicks, cart adds, and purchases
        #   with price data.
        attribute?(:price_and_count_metrics, PriceAndCountMetrics, from: "priceAndCountMetrics")

        # @return [AmountWithBenchmarking] Total revenue generated from purchases attributed to search traffic.
        attribute?(:traffic_sales, AmountWithBenchmarking, from: "trafficSales")
      end
    end
  end
end
