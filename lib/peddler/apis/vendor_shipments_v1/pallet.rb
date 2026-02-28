# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Details of the Pallet/Tare being shipped.
      Pallet = Structure.new do
        # @return [Array<ContainerIdentification>] A list of pallet identifiers.
        attribute(:pallet_identifiers, [ContainerIdentification], null: false, from: "palletIdentifiers")

        # @return [Integer] Number of cartons per layer on the pallet. Only applicable to container type Pallet.
        attribute?(:block, Integer)

        # @return [CartonReferenceDetails] Carton reference details.
        attribute?(:carton_reference_details, CartonReferenceDetails, from: "cartonReferenceDetails")

        # @return [Dimensions]
        attribute?(:dimensions, Dimensions)

        # @return [Array<ContainerItem>] A list of container item details.
        attribute?(:items, [ContainerItem])

        # @return [Integer] Number of layers per pallet. Only applicable to container type Pallet.
        attribute?(:tier, Integer)

        # @return [Weight]
        attribute?(:weight, Weight)
      end
    end
  end
end
