# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The A+ standard fixed-length list of text and a related headline.
      StandardHeaderTextListBlock = Structure.new do
        # @return [StandardTextListBlock]
        attribute?(:block, StandardTextListBlock)

        # @return [TextComponent]
        attribute?(:headline, TextComponent)
      end
    end
  end
end
