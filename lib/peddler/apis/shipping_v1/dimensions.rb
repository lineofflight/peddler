# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # A set of measurements for a three-dimensional object.
      Dimensions = Structure.new do
        # @return [Float] The height of the container.
        attribute(:height, Float, null: false)

        # @return [Float] The length of the container.
        attribute(:length, Float, null: false)

        # @return [String] The unit of these measurements.
        attribute(:unit, String, null: false)

        # @return [Float] The width of the container.
        attribute(:width, Float, null: false)
      end
    end
  end
end
