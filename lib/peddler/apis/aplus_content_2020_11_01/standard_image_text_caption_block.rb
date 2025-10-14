# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The A+ Content standard image and text block, with a related caption. The caption might not display on all
      # devices.
      StandardImageTextCaptionBlock = Structure.new do
        # @return [StandardImageTextBlock]
        attribute?(:block, StandardImageTextBlock)

        # @return [TextComponent]
        attribute?(:caption, TextComponent)
      end
    end
  end
end
