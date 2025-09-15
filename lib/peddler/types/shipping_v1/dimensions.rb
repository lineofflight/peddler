# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV1
      # A set of measurements for a three-dimensional object.
      Dimensions = Structure.new do
        # @return [Float] The length of the container.
        attribute(:length, Float)

        # @return [Float] The width of the container.
        attribute(:width, Float)

        # @return [Float] The height of the container.
        attribute(:height, Float)

        # @return [String] The unit of these measurements.
        attribute(:unit, String)
      end
    end
  end
end
