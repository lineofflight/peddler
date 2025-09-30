# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/text_component"
require "peddler/types/aplus_content_2020_11_01/standard_image_text_block"

module Peddler
  module Types
    module AplusContent20201101
      # Three standard images with text, presented across a single row.
      StandardThreeImageTextModule = Structure.new do
        # @return [TextComponent]
        attribute?(:headline, TextComponent)

        # @return [StandardImageTextBlock]
        attribute?(:block1, StandardImageTextBlock)

        # @return [StandardImageTextBlock]
        attribute?(:block2, StandardImageTextBlock)

        # @return [StandardImageTextBlock]
        attribute?(:block3, StandardImageTextBlock)
      end
    end
  end
end
