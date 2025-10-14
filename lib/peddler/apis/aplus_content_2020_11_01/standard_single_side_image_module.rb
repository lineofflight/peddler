# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
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
