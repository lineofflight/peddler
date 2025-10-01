# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # A set of measurements for a three-dimensional object.
      Dimensions = Structure.new do
        # @return [Float] The height of the package.
        attribute(:height, Float)

        # @return [Float] The length of the package.
        attribute(:length, Float)

        # @return [String] The unit of measurement.
        attribute(:unit, String)

        # @return [Float] The width of the package.
        attribute(:width, Float)
      end
    end
  end
end
