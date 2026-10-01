# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A single panel within the image carousel that features rich text elements, a direct link to a product ASIN, and
      # an image.
      ImageCarouselPanel = Structure.new do
        # @return [ImageComponent]
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        # @return [ImageComponent]
        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        # @return [Integer] The position of the panel within the carousel. Must be a value between 1 and 6.
        attribute(:position, Integer, null: false)

        # @return [TextComponent]
        attribute?(:asin, TextComponent)

        # @return [TextComponent]
        attribute?(:button_text, TextComponent, from: "buttonText")

        # @return [ParagraphComponent]
        attribute?(:description, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:title, TextComponent)
      end
    end
  end
end
