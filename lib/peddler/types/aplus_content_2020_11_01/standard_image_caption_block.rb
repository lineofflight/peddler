# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/text_component"
require "peddler/types/aplus_content_2020_11_01/image_component"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ Content standard image and caption block.
      StandardImageCaptionBlock = Structure.new do
        # @return [TextComponent]
        attribute?(:caption, TextComponent)

        # @return [ImageComponent]
        attribute?(:image, ImageComponent)
      end
    end
  end
end
