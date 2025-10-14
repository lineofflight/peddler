# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShipping20211228
      # Represents the confirmation details of a shipment, including the purchase order number and other shipment
      # details.
      ShipmentConfirmation = Structure.new do
        # @return [Array<Item>] Provide the details of the items in this shipment. If any of the item details field is
        # common at a package or a pallet level, then provide them at the corresponding package.
        attribute(:items, [Item])

        # @return [String] Purchase order number corresponding to the shipment.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [PartyIdentification] ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] Warehouse code of vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [ShipmentDetails] Shipment information.
        attribute(:shipment_details, ShipmentDetails, from: "shipmentDetails")

        # @return [Array<Container>] Provide the details of the items in this shipment. If any of the item details field
        # is common at a package or a pallet level, then provide them at the corresponding package.
        attribute?(:containers, [Container])
      end
    end
  end
end
