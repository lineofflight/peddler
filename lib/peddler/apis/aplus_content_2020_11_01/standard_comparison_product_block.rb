# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The A+ Content standard comparison product block.
      StandardComparisonProductBlock = Structure.new do
        # The rank or index of this comparison product block within the module. Different blocks cannot occupy the same
        # position within a single module.
        attribute(:position, Integer, null: false)

        attribute?(:asin, String)

        # Determines whether this block of content is visually highlighted.
        attribute?(:highlight, :boolean)

        attribute?(:image, ImageComponent)

        # Comparison metrics for the product.
        attribute?(:metrics, [PlainTextItem])

        # The comparison product title.
        attribute?(:title, String)
      end
    end
  end
end
