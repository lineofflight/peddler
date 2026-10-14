# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Measurement information for an order item.
      Measurement = Structure.new do
        # @return [String] The unit of measure. Known values: `OUNCES`, `POUNDS`, `KILOGRAMS`, `GRAMS`, `MILLIGRAMS`,
        #   `INCHES`, `FEET`, `METERS`, `CENTIMETERS`, `MILLIMETERS`, `SQUARE_METERS`, `SQUARE_CENTIMETERS`,
        #   `SQUARE_FEET`, `SQUARE_INCHES`, `GALLONS`, `PINTS`, `QUARTS`, `FLUID_OUNCES`, `LITERS`, `CUBIC_METERS`,
        #   `CUBIC_FEET`, `CUBIC_INCHES`, `CUBIC_CENTIMETERS`, `COUNT`.
        attribute(:unit, String, null: false, from: "Unit")

        # @return [Float] The measurement value.
        attribute(:value, Float, null: false, from: "Value")
      end
    end
  end
end
