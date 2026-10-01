# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A video paired with text containing subheadline, headline, and body text. The video can appear on the left or
      # right of the text block.
      PremiumVideoTextModule = Structure.new do
        # @return [TextComponent]
        attribute(:headline, TextComponent, null: false)

        # @return [String]
        attribute(:position_type, String, null: false, from: "positionType")

        # @return [VideoComponent]
        attribute(:video, VideoComponent, null: false)

        # @return [ParagraphComponent]
        attribute?(:description, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:title, TextComponent)
      end
    end
  end
end
