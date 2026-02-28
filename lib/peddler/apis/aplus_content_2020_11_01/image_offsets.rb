# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The top left corner of the cropped image, specified in the original image's coordinate space.
      ImageOffsets = Structure.new do
        # @return [IntegerWithUnits]
        attribute(:x, IntegerWithUnits, null: false)

        # @return [IntegerWithUnits]
        attribute(:y, IntegerWithUnits, null: false)
      end
    end
  end
end
