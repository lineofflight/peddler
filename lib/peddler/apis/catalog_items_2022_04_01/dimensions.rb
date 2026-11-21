# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module CatalogItems20220401
      # Dimensions of an Amazon catalog item or item in its packaging.
      Dimensions = Structure.new do
        # Height of an item or item package.
        attribute?(:height, Dimension)

        # Length of an item or item package.
        attribute?(:length, Dimension)

        # Weight of an item or item package.
        attribute?(:weight, Dimension)

        # Width of an item or item package.
        attribute?(:width, Dimension)
      end
    end
  end
end
