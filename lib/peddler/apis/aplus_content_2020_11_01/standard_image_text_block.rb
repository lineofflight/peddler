# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # The A+ Content standard image and text box block.
      StandardImageTextBlock = Structure.new do
        attribute?(:body, ParagraphComponent)

        attribute?(:headline, TextComponent)

        attribute?(:image, ImageComponent)
      end
    end
  end
end
