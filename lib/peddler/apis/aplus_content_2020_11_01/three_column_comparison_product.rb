# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A product in the three-column comparison table.
      ThreeColumnComparisonProduct = Structure.new do
        # @return [ImageComponent]
        attribute?(:image, ImageComponent)

        # @return [Integer] Location of the product within the comparison table. Must be a value between 1 and 3.
        attribute?(:position, Integer)

        # @return [TextComponent]
        attribute?(:product_asin, TextComponent, from: "productAsin")

        # @return [TextComponent]
        attribute?(:product_title, TextComponent, from: "productTitle")
      end
    end
  end
end
