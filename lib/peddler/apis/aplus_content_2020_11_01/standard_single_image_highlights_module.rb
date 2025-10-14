# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A standard image with several paragraphs and a bulleted list.
      StandardSingleImageHighlightsModule = Structure.new do
        # @return [StandardHeaderTextListBlock]
        attribute?(:bulleted_list_block, StandardHeaderTextListBlock, from: "bulletedListBlock")

        # @return [TextComponent]
        attribute?(:headline, TextComponent)

        # @return [ImageComponent]
        attribute?(:image, ImageComponent)

        # @return [StandardTextBlock]
        attribute?(:text_block1, StandardTextBlock, from: "textBlock1")

        # @return [StandardTextBlock]
        attribute?(:text_block2, StandardTextBlock, from: "textBlock2")

        # @return [StandardTextBlock]
        attribute?(:text_block3, StandardTextBlock, from: "textBlock3")
      end
    end
  end
end
