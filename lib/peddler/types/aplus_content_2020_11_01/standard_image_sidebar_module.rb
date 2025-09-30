# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/text_component"
require "peddler/types/aplus_content_2020_11_01/standard_image_caption_block"
require "peddler/types/aplus_content_2020_11_01/standard_text_block"
require "peddler/types/aplus_content_2020_11_01/standard_text_list_block"
require "peddler/types/aplus_content_2020_11_01/standard_image_text_block"

module Peddler
  module Types
    module AplusContent20201101
      # Two images, two paragraphs, and two bulleted lists. One image is smaller and displayed in the sidebar.
      StandardImageSidebarModule = Structure.new do
        # @return [TextComponent]
        attribute?(:headline, TextComponent)

        # @return [StandardImageCaptionBlock]
        attribute?(:image_caption_block, StandardImageCaptionBlock, from: "imageCaptionBlock")

        # @return [StandardTextBlock]
        attribute?(:description_text_block, StandardTextBlock, from: "descriptionTextBlock")

        # @return [StandardTextListBlock]
        attribute?(:description_list_block, StandardTextListBlock, from: "descriptionListBlock")

        # @return [StandardImageTextBlock]
        attribute?(:sidebar_image_text_block, StandardImageTextBlock, from: "sidebarImageTextBlock")

        # @return [StandardTextListBlock]
        attribute?(:sidebar_list_block, StandardTextListBlock, from: "sidebarListBlock")
      end
    end
  end
end
