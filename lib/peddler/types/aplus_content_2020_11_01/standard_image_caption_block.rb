# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/image_component"
require "peddler/types/aplus_content_2020_11_01/text_component"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ Content standard image and caption block.
      StandardImageCaptionBlock = Structure.new do
        # @return [ImageComponent]
        attribute?(:image, ImageComponent)

        # @return [TextComponent]
        attribute?(:caption, TextComponent)
      end
    end
  end
end
