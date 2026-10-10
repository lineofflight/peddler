# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A single panel within the image carousel that features rich text elements, a direct link to a product ASIN, and
      # an image.
      ImageCarouselPanel = Structure.new do
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        # The position of the panel within the carousel. Must be a value between 1 and 6.
        attribute(:position, Integer, null: false)

        attribute?(:asin, TextComponent)

        attribute?(:button_text, TextComponent, from: "buttonText")

        attribute?(:description, ParagraphComponent)

        attribute?(:title, TextComponent)
      end
    end
  end
end
