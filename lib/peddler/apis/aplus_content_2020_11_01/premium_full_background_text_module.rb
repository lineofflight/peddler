# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A full-width background image with a text overlay box containing subheadline, headline, and body text. The text
      # box can be positioned to the left or right, and styled light or dark.
      PremiumFullBackgroundTextModule = Structure.new do
        attribute(:color_type, String, null: false, from: "colorType")

        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        attribute(:position_type, String, null: false, from: "positionType")

        attribute?(:description, ParagraphComponent)

        attribute?(:headline, TextComponent)

        attribute?(:subheadline, TextComponent)
      end
    end
  end
end
