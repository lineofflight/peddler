# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Details of the item being shipped.
      Item = Structure.new do
        # @return [Integer] Item Sequence Number for the item. This must be the same value as sent in order for a given
        #   item.
        attribute(:item_sequence_number, Integer, from: "itemSequenceNumber")

        # @return [ItemQuantity] Total item quantity shipped in this shipment.
        attribute(:shipped_quantity, ItemQuantity, from: "shippedQuantity")

        # @return [String] Buyer's Standard Identification Number (ASIN) of an item. Either buyerProductIdentifier or
        #   vendorProductIdentifier is required.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] The vendor selected product identification of the item. Should be the same as was sent in the
        #   purchase order, like SKU Number.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
