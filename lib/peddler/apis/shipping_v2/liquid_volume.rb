# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Liquid Volume.
      LiquidVolume = Structure.new do
        # @return [String] The unit of measurement.
        attribute(:unit, String, null: false)

        # @return [Float] The measurement value.
        attribute(:value, Float, null: false)
      end
    end
  end
end
