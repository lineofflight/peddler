# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/standard_image_text_block"
require "peddler/types/aplus_content_2020_11_01/text_component"

module Peddler
  module Types
    module AplusContent20201101
      # Standard headline text, an image, and body text.
      StandardHeaderImageTextModule = Structure.new do
        # @return [StandardImageTextBlock]
        attribute?(:block, StandardImageTextBlock)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
