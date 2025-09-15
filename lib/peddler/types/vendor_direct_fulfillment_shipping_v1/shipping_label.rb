# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/party_identification"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/label_data"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Shipping label information for an order, including the purchase order number, selling party, ship from party,
      # label format, and package details.
      ShippingLabel = Structure.new do
        # @return [String] This field will contain the Purchase Order Number for this order.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [PartyIdentification] ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] Warehouse code of vendor.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [String] Format of the label.
        attribute(:label_format, String, from: "labelFormat")

        # @return [Array<LabelData>] Provides the details of the packages in this shipment.
        attribute(:label_data, [LabelData], from: "labelData")
      end
    end
  end
end
