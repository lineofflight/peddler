# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A wrapper object for a single ImageTextHotSpot.
      ImageTextHotSpots = Structure.new do
        # @return [ImageTextHotSpot]
        attribute(:image_text_hot_spot, ImageTextHotSpot, null: false, from: "imageTextHotSpot")
      end
    end
  end
end
