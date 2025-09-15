# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/integer_with_units"

module Peddler
  module Types
    module AplusContent20201101
      # The top left corner of the cropped image, specified in the original image's coordinate space.
      ImageOffsets = Structure.new do
        # @return [IntegerWithUnits]
        attribute(:x, IntegerWithUnits)

        # @return [IntegerWithUnits]
        attribute(:y, IntegerWithUnits)
      end
    end
  end
end
