# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # Two images, two paragraphs, and two bulleted lists. One image is smaller and displayed in the sidebar.
      StandardImageSidebarModule = Structure.new do
        attribute?(:description_list_block, StandardTextListBlock, from: "descriptionListBlock")

        attribute?(:description_text_block, StandardTextBlock, from: "descriptionTextBlock")

        attribute?(:headline, TextComponent)

        attribute?(:image_caption_block, StandardImageCaptionBlock, from: "imageCaptionBlock")

        attribute?(:sidebar_image_text_block, StandardImageTextBlock, from: "sidebarImageTextBlock")

        attribute?(:sidebar_list_block, StandardTextListBlock, from: "sidebarListBlock")
      end
    end
  end
end
