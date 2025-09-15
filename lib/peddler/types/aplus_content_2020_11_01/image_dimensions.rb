# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/integer_with_units"

module Peddler
  module Types
    module AplusContent20201101
      # The dimensions that extend from the top left corner of the image (this applies to cropped and uncropped images).
      # `ImageDimensions` units must be in pixels.
      ImageDimensions = Structure.new do
        # @return [IntegerWithUnits]
        attribute(:width, IntegerWithUnits)

        # @return [IntegerWithUnits]
        attribute(:height, IntegerWithUnits)
      end
    end
  end
end
