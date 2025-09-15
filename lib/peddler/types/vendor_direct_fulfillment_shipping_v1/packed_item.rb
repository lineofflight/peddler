# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/item_quantity"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Represents an item that has been packed into a container for shipping.
      PackedItem = Structure.new do
        # @return [Integer] Item Sequence Number for the item. This must be the same value as sent in the order for a
        # given item.
        attribute(:item_sequence_number, Integer, from: "itemSequenceNumber")

        # @return [String] Buyer's Standard Identification Number (ASIN) of an item. Either buyerProductIdentifier or
        # vendorProductIdentifier is required.
        attribute(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] The vendor selected product identification of the item. Should be the same as was sent in the
        # Purchase Order, like SKU Number.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [ItemQuantity] Total item quantity packed in the container.
        attribute(:packed_quantity, ItemQuantity, from: "packedQuantity")
      end
    end
  end
end
