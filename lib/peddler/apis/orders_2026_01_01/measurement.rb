# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Specifies the unit of measure and quantity for items that are sold by weight, volume, length, or other
      # measurements rather than simple count.
      Measurement = Structure.new do
        # @return [String] The specific unit of measurement used to quantify this item. Known values: `OUNCES`,
        #   `POUNDS`, `KILOGRAMS`, `GRAMS`, `MILLIGRAMS`, `INCHES`, `FEET`, `METERS`, `CENTIMETERS`, `MILLIMETERS`,
        #   `SQUARE_METERS`, `SQUARE_CENTIMETERS`, `SQUARE_FEET`, `SQUARE_INCHES`, `GALLONS`, `PINTS`, `QUARTS`,
        #   `FLUID_OUNCES`, `LITERS`, `CUBIC_METERS`, `CUBIC_FEET`, `CUBIC_INCHES`, `CUBIC_CENTIMETERS`, `COUNT`.
        attribute(:unit, String, null: false)

        # @return [Float] The numerical quantity or amount being measured in the specified unit.
        attribute(:value, Float, null: false)
      end
    end
  end
end
