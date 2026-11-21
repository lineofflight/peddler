# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A single panel within the regimen carousel that features rich text elements and an image.
      RegimenCarouselPanel = Structure.new do
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        attribute(:nav_text, TextComponent, null: false, from: "navText")

        # The position of the panel within the carousel. Must be a value between 1 and 5.
        attribute(:position, Integer, null: false)

        attribute?(:description, ParagraphComponent)

        attribute?(:title, TextComponent)
      end
    end
  end
end
