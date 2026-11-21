# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A standard image with paragraphs and a bulleted list, and extra space for technical details.
      StandardSingleImageSpecsDetailModule = Structure.new do
        attribute?(:description_block1, StandardTextBlock, from: "descriptionBlock1")

        attribute?(:description_block2, StandardTextBlock, from: "descriptionBlock2")

        attribute?(:description_headline, TextComponent, from: "descriptionHeadline")

        attribute?(:headline, TextComponent)

        attribute?(:image, ImageComponent)

        attribute?(:specification_headline, TextComponent, from: "specificationHeadline")

        attribute?(:specification_list_block, StandardHeaderTextListBlock, from: "specificationListBlock")

        attribute?(:specification_text_block, StandardTextBlock, from: "specificationTextBlock")
      end
    end
  end
end
