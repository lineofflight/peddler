# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/party_identification"
require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/package"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # The request body schema for the `createContainerLabel` operation.
      CreateContainerLabelRequest = Structure.new do
        # @return [PartyIdentification] The ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] The warehouse code of the vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [String] The container (pallet) label's carrier.
        attribute(:carrier_id, String, from: "carrierId")

        # @return [String] The vendor's unique identifier for the container.
        attribute(:vendor_container_id, String, from: "vendorContainerId")

        # @return [Array<Package>] An array of package objects that associate shipment packages with a container.
        attribute(:packages, [Package])
      end
    end
  end
end
