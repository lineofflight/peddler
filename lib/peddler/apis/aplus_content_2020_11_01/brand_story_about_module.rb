# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A Brand Story card with text-focused content for telling your Brand's story, mission, or values.
      BrandStoryAboutModule = Structure.new do
        attribute(:logo_image, ImageComponent, null: false, from: "logoImage")

        attribute?(:slogan, ParagraphComponent)

        attribute?(:title, TextComponent)
      end
    end
  end
end
