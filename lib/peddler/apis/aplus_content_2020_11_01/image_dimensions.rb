# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The dimensions that extend from the top left corner of the image (this applies to cropped and uncropped images).
      # `ImageDimensions` units must be in pixels.
      ImageDimensions = Structure.new do
        # @return [IntegerWithUnits]
        attribute(:height, IntegerWithUnits)

        # @return [IntegerWithUnits]
        attribute(:width, IntegerWithUnits)
      end
    end
  end
end
