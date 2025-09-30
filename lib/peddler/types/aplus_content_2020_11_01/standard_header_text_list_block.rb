# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/text_component"
require "peddler/types/aplus_content_2020_11_01/standard_text_list_block"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ standard fixed-length list of text and a related headline.
      StandardHeaderTextListBlock = Structure.new do
        # @return [TextComponent]
        attribute?(:headline, TextComponent)

        # @return [StandardTextListBlock]
        attribute?(:block, StandardTextListBlock)
      end
    end
  end
end
