# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A scrollable comparison view with full-height product images, chart headline, and feature rows with text per
      # product.
      PremiumComparisonScrollerModule = Structure.new do
        # @return [Array<ComparisonProducts>] The collection of comparison products, which must contain between 3 and 7
        #   products.
        attribute(:comparison_products, [ComparisonProducts], null: false, from: "comparisonProducts")

        # @return [Array<ComparisonMetrics>] The collection of comparison rows, which must contain between 5 and 12
        #   rows.
        attribute(:comparison_rows, [ComparisonMetrics], null: false, from: "comparisonRows")

        # @return [TextComponent]
        attribute(:headline, TextComponent, null: false)

        # @return [:boolean] Whether to show Add to Cart buttons.
        attribute?(:show_atc, :boolean, from: "showATC")

        # @return [:boolean] Whether to show product prices.
        attribute?(:show_prices, :boolean, from: "showPrices")

        # @return [:boolean] Whether to show product reviews.
        attribute?(:show_reviews, :boolean, from: "showReviews")
      end
    end
  end
end
