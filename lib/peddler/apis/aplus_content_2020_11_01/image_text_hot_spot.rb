# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A hotspot with mobile image, title, and coordinates.
      ImageTextHotSpot = Structure.new do
        # @return [ImageComponent]
        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        # @return [TextComponent]
        attribute(:title, TextComponent, null: false)

        # @return [TextComponent]
        attribute(:x_coordinate, TextComponent, null: false, from: "xCoordinate")

        # @return [TextComponent]
        attribute(:y_coordinate, TextComponent, null: false, from: "yCoordinate")
      end
    end
  end
end
