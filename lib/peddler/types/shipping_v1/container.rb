# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "peddler/types/shipping_v1/dimensions"
require "peddler/types/shipping_v1/container_item"
require "peddler/types/shipping_v1/weight"

module Peddler
  module Types
    module ShippingV1
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
