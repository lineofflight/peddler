# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The top left corner of the cropped image, specified in the original image's coordinate space.
      ImageOffsets = Structure.new do
        attribute(:x, IntegerWithUnits, null: false)

        attribute(:y, IntegerWithUnits, null: false)
      end
    end
  end
end
