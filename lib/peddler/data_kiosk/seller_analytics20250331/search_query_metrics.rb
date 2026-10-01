# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Search metrics at the query/keyword level.
      SearchQueryMetrics = Structure.new do
        # @return [PriceAndCountMetrics] Core search metrics including impressions, clicks, cart adds, and purchases
        #   with price data.
        attribute?(:price_and_count_metrics, PriceAndCountMetrics, from: "priceAndCountMetrics")

        # @return [String] Search query keyword entered by customers.
        # This field automatically groups results when selected, showing metrics per unique keyword.
        attribute?(:query_keyword, String, from: "queryKeyword")
      end
    end
  end
end
