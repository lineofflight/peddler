# frozen_string_literal: true

require "peddler/types/aplus_content_2020_11_01/text_component"

module Peddler
  module Types
    module AplusContent20201101
      # Rich positional text that is usually presented as a collection of bullet points.
      TextItem = Structure.new do
        # @return [Integer] The rank or index of this text item within the collection. Different items cannot occupy the
        # same position within a single collection.
        attribute(:position, Integer)

        # @return [TextComponent]
        attribute(:text, TextComponent)
      end
    end
  end
end
