# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/aplus_content_2020_11_01/text_component"

module Peddler
  module Types
    module AplusContent20201101
      # The A+ Content standard label and description block, which contains a pair of text components.
      StandardTextPairBlock = Structure.new do
        # @return [TextComponent]
        attribute?(:label, TextComponent)

        # @return [TextComponent]
        attribute?(:description, TextComponent)
      end
    end
  end
end
