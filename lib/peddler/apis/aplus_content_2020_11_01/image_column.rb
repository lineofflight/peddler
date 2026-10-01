# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A single column within a multi-column premium image module, containing an image, an optional headline, and an
      # optional description.
      ImageColumn = Structure.new do
        # @return [ImageComponent]
        attribute(:image, ImageComponent, null: false)

        # @return [Integer] Location of the column within the module.
        attribute(:position, Integer, null: false)

        # @return [ParagraphComponent]
        attribute?(:description, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
