# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A standard image with paragraphs, a bulleted list, and extra space for technical details.
      StandardSingleImageSpecsDetailModule = Structure.new do
        # @return [StandardTextBlock]
        attribute?(:description_block1, StandardTextBlock, from: "descriptionBlock1")

        # @return [StandardTextBlock]
        attribute?(:description_block2, StandardTextBlock, from: "descriptionBlock2")

        # @return [TextComponent]
        attribute?(:description_headline, TextComponent, from: "descriptionHeadline")

        # @return [TextComponent]
        attribute?(:headline, TextComponent)

        # @return [ImageComponent]
        attribute?(:image, ImageComponent)

        # @return [TextComponent]
        attribute?(:specification_headline, TextComponent, from: "specificationHeadline")

        # @return [StandardHeaderTextListBlock]
        attribute?(:specification_list_block, StandardHeaderTextListBlock, from: "specificationListBlock")

        # @return [StandardTextBlock]
        attribute?(:specification_text_block, StandardTextBlock, from: "specificationTextBlock")
      end
    end
  end
end
