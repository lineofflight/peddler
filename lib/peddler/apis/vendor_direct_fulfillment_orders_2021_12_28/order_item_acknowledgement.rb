# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrders20211228
      # Details of an individual item within the order being acknowledged.
      OrderItemAcknowledgement = Structure.new do
        # @return [ItemQuantity] Details of quantity acknowledged with the above acknowledgement code.
        attribute(:acknowledged_quantity, ItemQuantity, from: "acknowledgedQuantity")

        # @return [String] Line item sequence number for the item.
        attribute(:item_sequence_number, String, from: "itemSequenceNumber")

        # @return [String] Buyer's standard identification number (ASIN) of an item.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] The vendor selected product identification of the item. Should be the same as was provided in
        # the purchase order.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
