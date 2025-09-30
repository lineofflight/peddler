# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/standard_image_text_block"
require "peddler/types/aplus_content_2020_11_01/text_component"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ Content standard image and text block, with a related caption. The caption might not display on all
      # devices.
      StandardImageTextCaptionBlock = Structure.new do
        # @return [StandardImageTextBlock]
        attribute?(:block, StandardImageTextBlock)

        # @return [TextComponent]
        attribute?(:caption, TextComponent)
      end
    end
  end
end
