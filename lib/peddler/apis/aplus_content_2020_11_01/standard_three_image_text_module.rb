# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # Three standard images with text, presented across a single row.
      StandardThreeImageTextModule = Structure.new do
        attribute?(:block1, StandardImageTextBlock)

        attribute?(:block2, StandardImageTextBlock)

        attribute?(:block3, StandardImageTextBlock)

        attribute?(:headline, TextComponent)
      end
    end
  end
end
