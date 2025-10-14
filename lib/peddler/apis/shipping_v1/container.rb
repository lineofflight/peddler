# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # Container in the shipment.
      Container = Structure.new do
        # @return [String]
        attribute(:container_reference_id, String, from: "containerReferenceId")

        # @return [Dimensions] The length, width, height, and weight of the container.
        attribute(:dimensions, Dimensions)

        # @return [Array<ContainerItem>] A list of the items in the container.
        attribute(:items, [ContainerItem])

        # @return [Money] The total value of all items in the container.
        attribute(:value, Money)

        # @return [Weight] The weight of the container.
        attribute(:weight, Weight)

        # @return [String] The type of physical container being used. (always 'PACKAGE')
        attribute?(:container_type, String, from: "containerType")
      end
    end
  end
end
