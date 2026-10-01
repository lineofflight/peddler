# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A single image paired with text, positioned side by side. The image can appear on the left or right of the text
      # block.
      PremiumImageTextModule = Structure.new do
        # @return [TextComponent]
        attribute(:headline, TextComponent, null: false)

        # @return [ImageComponent]
        attribute(:image, ImageComponent, null: false)

        # @return [String]
        attribute(:position_type, String, null: false, from: "positionType")

        # @return [ParagraphComponent]
        attribute?(:body_text, ParagraphComponent, from: "bodyText")

        # @return [TextComponent]
        attribute?(:subheadline, TextComponent)
      end
    end
  end
end
