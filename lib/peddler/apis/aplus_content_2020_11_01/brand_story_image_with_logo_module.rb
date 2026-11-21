# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The required background card for all Brand Story Content. Provides a full-width background image with a Brand
      # logo overlay, headline, and body text. All other Brand Story modules appear within this carousel.
      BrandStoryImageWithLogoModule = Structure.new do
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        attribute?(:description, ParagraphComponent)

        attribute?(:title, TextComponent)
      end
    end
  end
end
