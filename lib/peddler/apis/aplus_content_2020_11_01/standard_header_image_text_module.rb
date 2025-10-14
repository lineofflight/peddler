# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Standard headline text, an image, and body text.
      StandardHeaderImageTextModule = Structure.new do
        # @return [StandardImageTextBlock]
        attribute?(:block, StandardImageTextBlock)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
