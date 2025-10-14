# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # The A+ Content standard label and description block, which contains a pair of text components.
      StandardTextPairBlock = Structure.new do
        # @return [TextComponent]
        attribute?(:description, TextComponent)

        # @return [TextComponent]
        attribute?(:label, TextComponent)
      end
    end
  end
end
