# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # A set of measurements for a three-dimensional object.
      Dimensions = Structure.new do
        # The height of the container.
        attribute(:height, Float, null: false)

        # The length of the container.
        attribute(:length, Float, null: false)

        # The unit of these measurements. Known values: `IN`, `CM`.
        attribute(:unit, String, null: false)

        # The width of the container.
        attribute(:width, Float, null: false)
      end
    end
  end
end
