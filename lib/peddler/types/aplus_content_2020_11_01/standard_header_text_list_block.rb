# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/aplus_content_2020_11_01/standard_text_list_block"
require "peddler/types/aplus_content_2020_11_01/text_component"

module Peddler
  module Types
    module AplusContent20201101
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
