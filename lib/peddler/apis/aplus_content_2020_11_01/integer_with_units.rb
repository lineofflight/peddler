# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      # A whole number dimension and its unit of measurement. For example, this can represent 100 pixels.
      IntegerWithUnits = Structure.new do
        # The unit of measurement.
        attribute(:units, String, null: false)

        # The dimension value.
        attribute(:value, Integer, null: false)
      end
    end
  end
end
