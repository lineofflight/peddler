# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShippingV1
      # Represents an item that has been packed into a container for shipping.
      PackedItem = Structure.new do
        # Item Sequence Number for the item. This must be the same value as sent in the order for a given item.
        attribute(:item_sequence_number, Integer, null: false, from: "itemSequenceNumber")

        # Total item quantity packed in the container.
        attribute(:packed_quantity, ItemQuantity, null: false, from: "packedQuantity")

        # Buyer's Standard Identification Number (ASIN) of an item. Either buyerProductIdentifier or
        # vendorProductIdentifier is required.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # The vendor selected product identification of the item. Should be the same as was sent in the Purchase Order,
        # like SKU Number.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
