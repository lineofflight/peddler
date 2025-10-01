# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/standard_header_text_list_block"
require "peddler/types/aplus_content_2020_11_01/text_component"
require "peddler/types/aplus_content_2020_11_01/image_component"
require "peddler/types/aplus_content_2020_11_01/standard_text_block"

module Peddler
  module Types
    module AplusContent20201101
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
