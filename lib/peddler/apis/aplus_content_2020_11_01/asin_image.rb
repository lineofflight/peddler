# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A single ASIN product with its associated image.
      ASINImage = Structure.new do
        # @return [TextComponent]
        attribute(:product_asin, TextComponent, null: false, from: "productAsin")

        # @return [ImageComponent]
        attribute(:product_image, ImageComponent, null: false, from: "productImage")
      end
    end
  end
end
