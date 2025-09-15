# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module AplusContent20201101
      # Plain positional text that is used in collections of brief labels and descriptors.
      PlainTextItem = Structure.new do
        # @return [Integer] The rank or index of this text item within the collection. Different items cannot occupy the
        # same position within a single collection.
        attribute(:position, Integer)

        # @return [String] The actual plain text.
        attribute(:value, String)
      end
    end
  end
end
