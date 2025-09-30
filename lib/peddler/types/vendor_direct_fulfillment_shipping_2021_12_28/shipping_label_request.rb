# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/party_identification"
require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/container"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Represents the request payload for creating a shipping label, containing the purchase order number, selling
      # party, ship from party, and a list of containers or packages in the shipment.
      ShippingLabelRequest = Structure.new do
        # @return [String] The purchase order number of the order for which to create a shipping label.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [PartyIdentification] The ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] The warehouse code of the vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [Array<Container>] A list of the packages in this shipment.
        attribute?(:containers, [Container])
      end
    end
  end
end
