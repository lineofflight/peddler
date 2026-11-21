# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A Brand Story card featuring a single image as the primary visual element.
      BrandStoryMediaAssetModule = Structure.new do
        attribute(:image, ImageComponent, null: false)

        attribute?(:description, ParagraphComponent)

        attribute?(:title, TextComponent)
      end
    end
  end
end
