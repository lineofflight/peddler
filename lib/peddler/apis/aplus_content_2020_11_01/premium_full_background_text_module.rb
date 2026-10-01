# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A full-width background image with a text overlay box containing subheadline, headline, and body text. The text
      # box can be positioned to the left or right, and styled light or dark.
      PremiumFullBackgroundTextModule = Structure.new do
        # @return [String]
        attribute(:color_type, String, null: false, from: "colorType")

        # @return [ImageComponent]
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        # @return [ImageComponent]
        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        # @return [String]
        attribute(:position_type, String, null: false, from: "positionType")

        # @return [ParagraphComponent]
        attribute?(:description, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)

        # @return [TextComponent]
        attribute?(:subheadline, TextComponent)
      end
    end
  end
end
