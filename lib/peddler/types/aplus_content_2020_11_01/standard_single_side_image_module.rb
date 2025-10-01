# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/standard_image_text_block"

module Peddler
  module Types
    module AplusContent20201101
      # A standard headline and body text with an image on the side.
      StandardSingleSideImageModule = Structure.new do
        # @return [String]
        attribute(:image_position_type, String, from: "imagePositionType")

        # @return [StandardImageTextBlock]
        attribute?(:block, StandardImageTextBlock)
      end
    end
  end
end
