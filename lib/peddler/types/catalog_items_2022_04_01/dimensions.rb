# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/catalog_items_2022_04_01/dimension"

module Peddler
  module Types
    module CatalogItems20220401
      # Dimensions of an Amazon catalog item or item in its packaging.
      Dimensions = Structure.new do
        # @return [Dimension] Height of an item or item package.
        attribute(:height, Dimension)

        # @return [Dimension] Length of an item or item package.
        attribute(:length, Dimension)

        # @return [Dimension] Weight of an item or item package.
        attribute(:weight, Dimension)

        # @return [Dimension] Width of an item or item package.
        attribute(:width, Dimension)
      end
    end
  end
end
