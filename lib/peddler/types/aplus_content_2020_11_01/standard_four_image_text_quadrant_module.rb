# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/standard_image_text_block"

module Peddler
  module Types
    module AplusContent20201101
      # Four standard images with text, presented on a grid of four quadrants.
      StandardFourImageTextQuadrantModule = Structure.new do
        # @return [StandardImageTextBlock]
        attribute(:block1, StandardImageTextBlock)

        # @return [StandardImageTextBlock]
        attribute(:block2, StandardImageTextBlock)

        # @return [StandardImageTextBlock]
        attribute(:block3, StandardImageTextBlock)

        # @return [StandardImageTextBlock]
        attribute(:block4, StandardImageTextBlock)
      end
    end
  end
end
