# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/image_component"
require "peddler/types/aplus_content_2020_11_01/text_component"
require "peddler/types/aplus_content_2020_11_01/standard_text_block"
require "peddler/types/aplus_content_2020_11_01/standard_header_text_list_block"

module Peddler
  module Types
    module AplusContent20201101
      # A standard image with several paragraphs and a bulleted list.
      StandardSingleImageHighlightsModule = Structure.new do
        # @return [ImageComponent]
        attribute(:image, ImageComponent)

        # @return [TextComponent]
        attribute(:headline, TextComponent)

        # @return [StandardTextBlock]
        attribute(:text_block1, StandardTextBlock, from: "textBlock1")

        # @return [StandardTextBlock]
        attribute(:text_block2, StandardTextBlock, from: "textBlock2")

        # @return [StandardTextBlock]
        attribute(:text_block3, StandardTextBlock, from: "textBlock3")

        # @return [StandardHeaderTextListBlock]
        attribute(:bulleted_list_block, StandardHeaderTextListBlock, from: "bulletedListBlock")
      end
    end
  end
end
