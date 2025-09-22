# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/party_identification"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/container"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Represents the request payload for creating a shipping label, containing the purchase order number, selling
      # party, ship from party, and a list of containers or packages in the shipment.
      ShippingLabelRequest = Structure.new do
        # @return [String] Purchase order number of the order for which to create a shipping label.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [PartyIdentification] ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] Warehouse code of vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [Array<Container>] A list of the packages in this shipment.
        attribute(:containers, [Container])
      end
    end
  end
end
