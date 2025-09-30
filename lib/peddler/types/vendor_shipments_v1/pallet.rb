# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/container_identification"
require "peddler/types/vendor_shipments_v1/dimensions"
require "peddler/types/vendor_shipments_v1/weight"
require "peddler/types/vendor_shipments_v1/carton_reference_details"
require "peddler/types/vendor_shipments_v1/container_item"

module Peddler
  module Types
    module VendorShipmentsV1
      # Details of the Pallet/Tare being shipped.
      Pallet = Structure.new do
        # @return [Array<ContainerIdentification>] A list of pallet identifiers.
        attribute(:pallet_identifiers, [ContainerIdentification], from: "palletIdentifiers")

        # @return [Integer] Number of layers per pallet. Only applicable to container type Pallet.
        attribute?(:tier, Integer)

        # @return [Integer] Number of cartons per layer on the pallet. Only applicable to container type Pallet.
        attribute?(:block, Integer)

        # @return [Dimensions]
        attribute?(:dimensions, Dimensions)

        # @return [Weight]
        attribute?(:weight, Weight)

        # @return [CartonReferenceDetails] Carton reference details.
        attribute?(:carton_reference_details, CartonReferenceDetails, from: "cartonReferenceDetails")

        # @return [Array<ContainerItem>] A list of container item details.
        attribute?(:items, [ContainerItem])
      end
    end
  end
end
