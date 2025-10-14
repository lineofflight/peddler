# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShipping20211228
      # The request body schema for the `createContainerLabel` operation.
      CreateContainerLabelRequest = Structure.new do
        # @return [String] The container (pallet) label's carrier.
        attribute(:carrier_id, String, from: "carrierId")

        # @return [Array<Package>] An array of package objects that associate shipment packages with a container.
        attribute(:packages, [Package])

        # @return [PartyIdentification] The ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] The warehouse code of the vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [String] The vendor's unique identifier for the container.
        attribute(:vendor_container_id, String, from: "vendorContainerId")
      end
    end
  end
end
