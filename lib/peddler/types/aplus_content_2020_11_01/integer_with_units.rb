# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AplusContent20201101
      # A whole number dimension and its unit of measurement. For example, this can represent 100 pixels.
      IntegerWithUnits = Structure.new do
        # @return [Integer] The dimension value.
        attribute(:value, Integer)

        # @return [String] The unit of measurement.
        attribute(:units, String)
      end
    end
  end
end
