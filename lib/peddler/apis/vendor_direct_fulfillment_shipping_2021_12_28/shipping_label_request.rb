# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShipping20211228
      # Represents the request payload for creating a shipping label, containing the purchase order number, selling
      # party, ship from party, and a list of containers or packages in the shipment.
      ShippingLabelRequest = Structure.new do
        # The purchase order number of the order for which to create a shipping label.
        attribute(:purchase_order_number, String, null: false, from: "purchaseOrderNumber")

        # The ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, null: false, from: "sellingParty")

        # The warehouse code of the vendor.
        attribute(:ship_from_party, PartyIdentification, null: false, from: "shipFromParty")

        # A list of the packages in this shipment.
        attribute?(:containers, [Container])
      end
    end
  end
end
