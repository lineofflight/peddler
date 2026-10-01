# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A Brand Story card featuring a single image as the primary visual element.
      BrandStoryMediaAssetModule = Structure.new do
        # @return [ImageComponent]
        attribute(:image, ImageComponent, null: false)

        # @return [ParagraphComponent]
        attribute?(:description, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:title, TextComponent)
      end
    end
  end
end
