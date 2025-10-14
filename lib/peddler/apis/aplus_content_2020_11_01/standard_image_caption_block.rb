# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
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
