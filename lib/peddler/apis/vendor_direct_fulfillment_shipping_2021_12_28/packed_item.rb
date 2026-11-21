# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShipping20211228
      # An item that has been packed into a container for shipping.
      PackedItem = Structure.new do
        # The sequence number of the item. The number must be the same as the order number of the item.
        attribute(:item_sequence_number, Integer, null: false, from: "itemSequenceNumber")

        # The total quantity of items that are packed in the shipment.
        attribute(:packed_quantity, ItemQuantity, null: false, from: "packedQuantity")

        # The buyer's Amazon Standard Identification Number (ASIN) of an item. Either `buyerProductIdentifier` or
        # `vendorProductIdentifier` is required.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # The piece number of the item in this container. This is required when the item is split across different
        # containers.
        attribute?(:piece_number, Integer, from: "pieceNumber")

        # An item's product identifier, which the vendor selects. This identifier should be the same as the identifier,
        # such as a SKU, in the purchase order.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
