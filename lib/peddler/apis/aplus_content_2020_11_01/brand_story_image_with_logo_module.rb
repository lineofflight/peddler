# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The required background card for all Brand Story Content. Provides a full-width background image with a Brand
      # logo overlay, headline, and body text. All other Brand Story modules appear within this carousel.
      BrandStoryImageWithLogoModule = Structure.new do
        # @return [ImageComponent]
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        # @return [ImageComponent]
        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        # @return [ParagraphComponent]
        attribute?(:description, ParagraphComponent)

        # @return [TextComponent]
        attribute?(:title, TextComponent)
      end
    end
  end
end
