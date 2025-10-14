# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Shipping label information for an order, including the purchase order number, selling party, ship from party,
      # label format, and package details.
      ShippingLabel = Structure.new do
        # @return [Array<LabelData>] Provides the details of the packages in this shipment.
        attribute(:label_data, [LabelData], from: "labelData")

        # @return [String] Format of the label.
        attribute(:label_format, String, from: "labelFormat")

        # @return [String] This field will contain the Purchase Order Number for this order.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [PartyIdentification] ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] Warehouse code of vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")
      end
    end
  end
end
