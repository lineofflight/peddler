# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The A+ Content standard image and text box block.
      StandardImageTextBlock = Structure.new do
        # @return [ParagraphComponent]
        attribute?(:body, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)

        # @return [ImageComponent]
        attribute?(:image, ImageComponent)
      end
    end
  end
end
