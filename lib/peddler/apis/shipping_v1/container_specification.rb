# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # Container specification for checking the service rate.
      ContainerSpecification = Structure.new do
        # @return [Dimensions] The length, width, and height of the container.
        attribute(:dimensions, Dimensions, null: false)

        # @return [Weight] The weight of the container.
        attribute(:weight, Weight, null: false)
      end
    end
  end
end
