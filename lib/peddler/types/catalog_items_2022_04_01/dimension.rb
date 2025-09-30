# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module CatalogItems20220401
      # The value of an individual dimension for an Amazon catalog item or item package.
      Dimension = Structure.new do
        # @return [String] Unit of measurement for the dimension value.
        attribute?(:unit, String)

        # @return [Float] Numeric value of the dimension.
        attribute?(:value, Float)
      end
    end
  end
end
