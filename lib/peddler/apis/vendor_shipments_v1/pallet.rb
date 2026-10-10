# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # Details of the Pallet/Tare being shipped.
      Pallet = Structure.new do
        # A list of pallet identifiers.
        attribute(:pallet_identifiers, [ContainerIdentification], null: false, from: "palletIdentifiers")

        # Number of cartons per layer on the pallet. Only applicable to container type Pallet.
        attribute?(:block, Integer)

        # Carton reference details.
        attribute?(:carton_reference_details, CartonReferenceDetails, from: "cartonReferenceDetails")

        attribute?(:dimensions, Dimensions)

        # A list of container item details.
        attribute?(:items, [ContainerItem])

        # Number of layers per pallet. Only applicable to container type Pallet.
        attribute?(:tier, Integer)

        attribute?(:weight, Weight)
      end
    end
  end
end
