# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # Four standard images with text, presented on a grid of four quadrants.
      StandardFourImageTextQuadrantModule = Structure.new do
        attribute(:block1, StandardImageTextBlock, null: false)

        attribute(:block2, StandardImageTextBlock, null: false)

        attribute(:block3, StandardImageTextBlock, null: false)

        attribute(:block4, StandardImageTextBlock, null: false)
      end
    end
  end
end
