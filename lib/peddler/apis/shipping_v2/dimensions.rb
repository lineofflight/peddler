# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # A set of measurements for a three-dimensional object.
      Dimensions = Structure.new do
        # The height of the package.
        attribute(:height, Float, null: false)

        # The length of the package.
        attribute(:length, Float, null: false)

        # The unit of measurement.
        attribute(:unit, String, null: false)

        # The width of the package.
        attribute(:width, Float, null: false)
      end
    end
  end
end
