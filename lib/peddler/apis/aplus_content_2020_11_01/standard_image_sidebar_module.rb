# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Two images, two paragraphs, and two bulleted lists. One image is smaller and displayed in the sidebar.
      StandardImageSidebarModule = Structure.new do
        # @return [StandardTextListBlock]
        attribute?(:description_list_block, StandardTextListBlock, from: "descriptionListBlock")

        # @return [StandardTextBlock]
        attribute?(:description_text_block, StandardTextBlock, from: "descriptionTextBlock")

        # @return [TextComponent]
        attribute?(:headline, TextComponent)

        # @return [StandardImageCaptionBlock]
        attribute?(:image_caption_block, StandardImageCaptionBlock, from: "imageCaptionBlock")

        # @return [StandardImageTextBlock]
        attribute?(:sidebar_image_text_block, StandardImageTextBlock, from: "sidebarImageTextBlock")

        # @return [StandardTextListBlock]
        attribute?(:sidebar_list_block, StandardTextListBlock, from: "sidebarListBlock")
      end
    end
  end
end
