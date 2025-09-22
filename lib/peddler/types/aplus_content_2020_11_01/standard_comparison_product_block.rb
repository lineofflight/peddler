# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/image_component"
require "peddler/types/aplus_content_2020_11_01/plain_text_item"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ Content standard comparison product block.
      StandardComparisonProductBlock = Structure.new do
        # @return [Integer] The rank or index of this comparison product block within the module. Different blocks
        # cannot occupy the same position within a single module.
        attribute(:position, Integer)

        # @return [ImageComponent]
        attribute(:image, ImageComponent)

        # @return [String] The comparison product title.
        attribute(:title, String)

        # @return [String]
        attribute(:asin, String)

        # @return [:boolean] When true, indicates that this content block is visually highlighted.
        attribute(:highlight, :boolean)

        # @return [Array<PlainTextItem>] Comparison metrics for the product.
        attribute(:metrics, [PlainTextItem])
      end
    end
  end
end
