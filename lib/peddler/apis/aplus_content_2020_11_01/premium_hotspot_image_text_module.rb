# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A full-width image with clickable hotspot markers, plus a module headline and body text above the image.
      PremiumHotspotImageTextModule = Structure.new do
        # @return [ImageComponent]
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        # @return [TextComponent]
        attribute(:headline, TextComponent, null: false)

        # @return [Array<ImageTextHotSpots>] The collection of hotspots, which must contain between 2 and 6 hotspots.
        attribute(:hot_spots, [ImageTextHotSpots], null: false, from: "hotSpots")

        # @return [ParagraphComponent]
        attribute?(:main_description, ParagraphComponent, from: "mainDescription")
      end
    end
  end
end
