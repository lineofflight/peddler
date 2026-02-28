# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The A+ Content standard comparison product block.
      StandardComparisonProductBlock = Structure.new do
        # @return [Integer] The rank or index of this comparison product block within the module. Different blocks
        #   cannot occupy the same position within a single module.
        attribute(:position, Integer, null: false)

        # @return [String]
        attribute?(:asin, String)

        # @return [:boolean] When true, indicates that this content block is visually highlighted.
        attribute?(:highlight, :boolean)

        # @return [ImageComponent]
        attribute?(:image, ImageComponent)

        # @return [Array<PlainTextItem>] Comparison metrics for the product.
        attribute?(:metrics, [PlainTextItem])

        # @return [String] The comparison product title.
        attribute?(:title, String)
      end
    end
  end
end
