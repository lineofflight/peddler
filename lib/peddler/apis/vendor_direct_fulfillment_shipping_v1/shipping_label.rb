# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShippingV1
      # Shipping label information for an order, including the purchase order number, selling party, ship from party,
      # label format, and package details.
      ShippingLabel = Structure.new do
        # Provides the details of the packages in this shipment.
        attribute(:label_data, [LabelData], null: false, from: "labelData")

        # Format of the label. Known values: `PNG`, `ZPL`.
        attribute(:label_format, String, null: false, from: "labelFormat")

        # This field will contain the Purchase Order Number for this order.
        attribute(:purchase_order_number, String, null: false, from: "purchaseOrderNumber")

        # ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, null: false, from: "sellingParty")

        # Warehouse code of vendor.
        attribute(:ship_from_party, PartyIdentification, null: false, from: "shipFromParty")
      end
    end
  end
end
