# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single ImageHotSpot.
      ImageHotSpots = Structure.new do
        # @return [ImageHotSpot]
        attribute(:image_hot_spot, ImageHotSpot, null: false, from: "imageHotSpot")
      end
    end
  end
end
