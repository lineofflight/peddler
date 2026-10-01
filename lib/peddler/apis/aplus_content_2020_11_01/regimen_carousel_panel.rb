# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A single panel within the regimen carousel that features rich text elements and an image.
      RegimenCarouselPanel = Structure.new do
        # @return [ImageComponent]
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        # @return [ImageComponent]
        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        # @return [TextComponent]
        attribute(:nav_text, TextComponent, null: false, from: "navText")

        # @return [Integer] The position of the panel within the carousel. Must be a value between 1 and 5.
        attribute(:position, Integer, null: false)

        # @return [ParagraphComponent]
        attribute?(:description, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:title, TextComponent)
      end
    end
  end
end
