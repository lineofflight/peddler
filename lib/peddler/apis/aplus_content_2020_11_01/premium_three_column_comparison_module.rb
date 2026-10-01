# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A comparison table displaying products side by side with features, tooltips, and detail rows.
      PremiumThreeColumnComparisonModule = Structure.new do
        # @return [Array<ThreeColumnComparisonProduct>] The three products being compared. Exactly three products are
        #   required.
        attribute(:comparison_products, [ThreeColumnComparisonProduct], null: false, from: "comparisonProducts")

        # @return [Array<ThreeColumnComparisonRow>] The rows of the comparison table. Each row represents a metric
        #   compared across all three products.
        attribute(:comparison_rows, [ThreeColumnComparisonRow], null: false, from: "comparisonRows")

        # @return [TextComponent]
        attribute(:headline, TextComponent, null: false)
      end
    end
  end
end
