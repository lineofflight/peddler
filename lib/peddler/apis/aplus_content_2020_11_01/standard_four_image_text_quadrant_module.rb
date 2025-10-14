# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
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
