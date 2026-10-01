# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A comparison table with product images, headline per product, and feature rows with text.
      PremiumComparisonCarouselModule = Structure.new do
        # @return [Array<ComparisonMetrics>] The collection of comparison metrics, which must contain between 3 and 7
        #   metrics.
        attribute(:comparison_metrics, [ComparisonMetrics], null: false, from: "comparisonMetrics")

        # @return [Array<ComparisonProducts>] The collection of comparison products, which must contain between 3 and 5
        #   products.
        attribute(:comparison_products, [ComparisonProducts], null: false, from: "comparisonProducts")

        # @return [TextComponent]
        attribute(:headline, TextComponent, null: false)
      end
    end
  end
end
