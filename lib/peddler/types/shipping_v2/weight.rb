# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The weight in the units indicated.
      Weight = Structure.new do
        # @return [String] The unit of measurement.
        attribute(:unit, String)

        # @return [Float] The measurement value.
        attribute(:value, Float)
      end
    end
  end
end
