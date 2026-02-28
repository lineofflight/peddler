# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # A set of measurements for a three-dimensional object.
      Dimensions = Structure.new do
        # @return [Float] The height of the package.
        attribute(:height, Float, null: false)

        # @return [Float] The length of the package.
        attribute(:length, Float, null: false)

        # @return [String] The unit of measurement.
        attribute(:unit, String, null: false)

        # @return [Float] The width of the package.
        attribute(:width, Float, null: false)
      end
    end
  end
end
