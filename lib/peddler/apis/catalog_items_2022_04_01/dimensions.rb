# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class CatalogItems20220401
      # Dimensions of an Amazon catalog item or item in its packaging.
      Dimensions = Structure.new do
        # @return [Dimension] Height of an item or item package.
        attribute?(:height, Dimension)

        # @return [Dimension] Length of an item or item package.
        attribute?(:length, Dimension)

        # @return [Dimension] Weight of an item or item package.
        attribute?(:weight, Dimension)

        # @return [Dimension] Width of an item or item package.
        attribute?(:width, Dimension)
      end
    end
  end
end
