# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A product in the comparison table carousel modules.
      ComparisonProduct = Structure.new do
        attribute?(:desktop_image, ImageComponent, from: "desktopImage")

        attribute?(:mobile_image, ImageComponent, from: "mobileImage")

        # The position of the product in comparison display.
        attribute?(:position, Integer)

        attribute?(:product_asin, TextComponent, from: "productAsin")

        attribute?(:product_title, TextComponent, from: "productTitle")
      end
    end
  end
end
