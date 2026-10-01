# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The dimensions extending from the top left corner of the cropped image, or the top left corner of the original
      # image if there is no cropping. Only `pixels` is allowed as the units value for ImageDimensions.
      ImageDimensions = Structure.new do
        # @return [IntegerWithUnits]
        attribute(:height, IntegerWithUnits, null: false)

        # @return [IntegerWithUnits]
        attribute(:width, IntegerWithUnits, null: false)
      end
    end
  end
end
