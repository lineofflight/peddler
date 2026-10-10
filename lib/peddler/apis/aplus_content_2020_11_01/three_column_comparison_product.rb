# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A product in the three-column comparison table.
      ThreeColumnComparisonProduct = Structure.new do
        attribute?(:image, ImageComponent)

        # Location of the product within the comparison table. Must be a value between 1 and 3.
        attribute?(:position, Integer)

        attribute?(:product_asin, TextComponent, from: "productAsin")

        attribute?(:product_title, TextComponent, from: "productTitle")
      end
    end
  end
end
