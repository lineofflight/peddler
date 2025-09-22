# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/dimensions"
require "peddler/types/shipping_v1/weight"

module Peddler
  module Types
    module ShippingV1
      # Container specification for checking the service rate.
      ContainerSpecification = Structure.new do
        # @return [Dimensions] The length, width, and height of the container.
        attribute(:dimensions, Dimensions)

        # @return [Weight] The weight of the container.
        attribute(:weight, Weight)
      end
    end
  end
end
