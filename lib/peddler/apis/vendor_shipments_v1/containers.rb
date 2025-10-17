# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # A list of the items in this transportation and their associated inner container details. If any of the item
      # detail fields are common at a carton or a pallet level, provide them at the corresponding carton or pallet
      # level.
      Containers = Structure.new do
        # @return [Array<ContainerIdentification>] A list of carton identifiers.
        attribute(:container_identifiers, [ContainerIdentification], from: "containerIdentifiers")

        # @return [String] The type of container.
        attribute(:container_type, String, from: "containerType")

        # @return [Integer] Number of cartons per layer on the pallet.
        attribute?(:block, Integer)

        # @return [String] An integer that must be submitted for multi-box shipments only, where one item may come in
        #   separate packages.
        attribute?(:container_sequence_number, String, from: "containerSequenceNumber")

        # @return [Dimensions]
        attribute?(:dimensions, Dimensions)

        # @return [InnerContainersDetails]
        attribute?(:inner_containers_details, InnerContainersDetails, from: "innerContainersDetails")

        # @return [Array<PackedItems>] A list of packed items.
        attribute?(:packed_items, [PackedItems], from: "packedItems")

        # @return [Integer] Number of layers per pallet.
        attribute?(:tier, Integer)

        # @return [String] The tracking number used for identifying the shipment.
        attribute?(:tracking_number, String, from: "trackingNumber")

        # @return [Weight]
        attribute?(:weight, Weight)
      end
    end
  end
end
