# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The A+ Content standard image and caption block.
      StandardImageCaptionBlock = Structure.new do
        attribute?(:caption, TextComponent)

        attribute?(:image, ImageComponent)
      end
    end
  end
end
