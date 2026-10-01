# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A product in the comparison table carousel modules.
      ComparisonProduct = Structure.new do
        # @return [ImageComponent]
        attribute?(:desktop_image, ImageComponent, from: "desktopImage")

        # @return [ImageComponent]
        attribute?(:mobile_image, ImageComponent, from: "mobileImage")

        # @return [Integer] The position of the product in comparison display.
        attribute?(:position, Integer)

        # @return [TextComponent]
        attribute?(:product_asin, TextComponent, from: "productAsin")

        # @return [TextComponent]
        attribute?(:product_title, TextComponent, from: "productTitle")
      end
    end
  end
end
