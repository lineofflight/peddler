# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/text_component"
require "peddler/types/aplus_content_2020_11_01/image_component"
require "peddler/types/aplus_content_2020_11_01/standard_text_block"
require "peddler/types/aplus_content_2020_11_01/standard_header_text_list_block"

module Peddler
  module Types
    module AplusContent20201101
      # A standard image with paragraphs, a bulleted list, and extra space for technical details.
      StandardSingleImageSpecsDetailModule = Structure.new do
        # @return [TextComponent]
        attribute(:headline, TextComponent)

        # @return [ImageComponent]
        attribute(:image, ImageComponent)

        # @return [TextComponent]
        attribute(:description_headline, TextComponent, from: "descriptionHeadline")

        # @return [StandardTextBlock]
        attribute(:description_block1, StandardTextBlock, from: "descriptionBlock1")

        # @return [StandardTextBlock]
        attribute(:description_block2, StandardTextBlock, from: "descriptionBlock2")

        # @return [TextComponent]
        attribute(:specification_headline, TextComponent, from: "specificationHeadline")

        # @return [StandardHeaderTextListBlock]
        attribute(:specification_list_block, StandardHeaderTextListBlock, from: "specificationListBlock")

        # @return [StandardTextBlock]
        attribute(:specification_text_block, StandardTextBlock, from: "specificationTextBlock")
      end
    end
  end
end
