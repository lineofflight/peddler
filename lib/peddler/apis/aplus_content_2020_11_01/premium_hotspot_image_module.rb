# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A full-width image with clickable hotspot markers that reveal headline and descriptive text for each point of
      # interest.
      PremiumHotspotImageModule = Structure.new do
        # @return [ImageComponent]
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        # @return [Array<ImageHotSpots>] The collection of hotspots, which must contain between 2 and 6 hotspots.
        attribute(:hot_spots, [ImageHotSpots], null: false, from: "hotSpots")
      end
    end
  end
end
