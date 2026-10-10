# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A full-width background image that spans the entire module width, with optional headline and body text below.
      PremiumFullBackgroundImageModule = Structure.new do
        attribute(:desktop_image, ImageComponent, null: false, from: "desktopImage")

        attribute(:mobile_image, ImageComponent, null: false, from: "mobileImage")

        attribute?(:footer, ParagraphComponent)

        attribute?(:headline, TextComponent)
      end
    end
  end
end
