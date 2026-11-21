# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A standard image with several paragraphs and a bulleted list.
      StandardSingleImageHighlightsModule = Structure.new do
        attribute?(:bulleted_list_block, StandardHeaderTextListBlock, from: "bulletedListBlock")

        attribute?(:headline, TextComponent)

        attribute?(:image, ImageComponent)

        attribute?(:text_block1, StandardTextBlock, from: "textBlock1")

        attribute?(:text_block2, StandardTextBlock, from: "textBlock2")

        attribute?(:text_block3, StandardTextBlock, from: "textBlock3")
      end
    end
  end
end
