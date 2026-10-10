# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # Plain positional text, used in collections of brief labels and descriptors.
      PlainTextItem = Structure.new do
        # The rank or index of this text item within the collection. Different items cannot occupy the same position
        # within a single collection.
        attribute(:position, Integer, null: false)

        # The actual plain text.
        attribute(:value, String, null: false)
      end
    end
  end
end
