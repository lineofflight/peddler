# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShipping20211228
      # The request body schema for the `createContainerLabel` operation.
      CreateContainerLabelRequest = Structure.new do
        # The container (pallet) label's carrier.
        attribute(:carrier_id, String, null: false, from: "carrierId")

        # An array of package objects that associate shipment packages with a container.
        attribute(:packages, [Package], null: false)

        # The ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, null: false, from: "sellingParty")

        # The warehouse code of the vendor.
        attribute(:ship_from_party, PartyIdentification, null: false, from: "shipFromParty")

        # The vendor's unique identifier for the container.
        attribute(:vendor_container_id, String, null: false, from: "vendorContainerId")
      end
    end
  end
end
