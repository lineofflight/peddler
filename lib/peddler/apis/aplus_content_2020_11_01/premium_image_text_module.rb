# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A single image paired with text, positioned side by side. The image can appear on the left or right of the text
      # block.
      PremiumImageTextModule = Structure.new do
        attribute(:headline, TextComponent, null: false)

        attribute(:image, ImageComponent, null: false)

        attribute(:position_type, String, null: false, from: "positionType")

        attribute?(:body_text, ParagraphComponent, from: "bodyText")

        attribute?(:subheadline, TextComponent)
      end
    end
  end
end
