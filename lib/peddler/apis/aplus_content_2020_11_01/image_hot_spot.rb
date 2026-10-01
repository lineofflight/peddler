# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A hotspot with mobile image, title, description, and coordinates.
      ImageHotSpot = Structure.new do
        # @return [ImageComponent]
        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        # @return [TextComponent]
        attribute(:title, TextComponent, null: false)

        # @return [TextComponent]
        attribute(:x_coordinate, TextComponent, null: false, from: "xCoordinate")

        # @return [TextComponent]
        attribute(:y_coordinate, TextComponent, null: false, from: "yCoordinate")

        # @return [TextComponent]
        attribute?(:description, TextComponent)
      end
    end
  end
end
