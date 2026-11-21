# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A video paired with text containing subheadline, headline, and body text. The video can appear on the left or
      # right of the text block.
      PremiumVideoTextModule = Structure.new do
        attribute(:headline, TextComponent, null: false)

        # Known values: `LEFT`, `RIGHT`.
        attribute(:position_type, String, null: false, from: "positionType")

        attribute(:video, VideoComponent, null: false)

        attribute?(:description, ParagraphComponent)

        attribute?(:title, TextComponent)
      end
    end
  end
end
