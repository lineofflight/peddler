# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Rich positional text that is usually presented as a collection of bullet points.
      TextItem = Structure.new do
        # @return [Integer] The rank or index of this text item within the collection. Different items cannot occupy the
        #   same position within a single collection.
        attribute(:position, Integer)

        # @return [TextComponent]
        attribute(:text, TextComponent)
      end
    end
  end
end
