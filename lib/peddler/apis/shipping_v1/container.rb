# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # Container in the shipment.
      Container = Structure.new do
        attribute(:container_reference_id, String, null: false, from: "containerReferenceId")

        # The length, width, height, and weight of the container.
        attribute(:dimensions, Dimensions, null: false)

        # A list of the items in the container.
        attribute(:items, [ContainerItem], null: false)

        # The total value of all items in the container.
        attribute(:value, Money, null: false)

        # The weight of the container.
        attribute(:weight, Weight, null: false)

        # The type of physical container being used. (always 'PACKAGE')
        attribute?(:container_type, String, from: "containerType")
      end
    end
  end
end
