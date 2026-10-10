# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A hotspot with mobile image, title, and coordinates.
      ImageTextHotSpot = Structure.new do
        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        attribute(:title, TextComponent, null: false)

        attribute(:x_coordinate, TextComponent, null: false, from: "xCoordinate")

        attribute(:y_coordinate, TextComponent, null: false, from: "yCoordinate")
      end
    end
  end
end
