# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_orders_v1/item_quantity"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # Details of an individual item within the order being acknowledged.
      OrderItemAcknowledgement = Structure.new do
        # @return [String] Line item sequence number for the item.
        attribute(:item_sequence_number, String, from: "itemSequenceNumber")

        # @return [String] Buyer's standard identification number (ASIN) of an item.
        attribute(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] The vendor selected product identification of the item. Should be the same as was provided in
        # the purchase order.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [ItemQuantity] Details of quantity acknowledged with the above acknowledgement code.
        attribute(:acknowledged_quantity, ItemQuantity, from: "acknowledgedQuantity")
      end
    end
  end
end
