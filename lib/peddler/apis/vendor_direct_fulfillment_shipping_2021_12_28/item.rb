# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShipping20211228
      # Details of the item being shipped.
      Item = Structure.new do
        # The sequence number of the item. The number must be the same as the order number of the item.
        attribute(:item_sequence_number, Integer, null: false, from: "itemSequenceNumber")

        # The total quantity of items that are in this shipment.
        attribute(:shipped_quantity, ItemQuantity, null: false, from: "shippedQuantity")

        # The buyer's Amazon Standard Identification Number (ASIN) of an item. Either `buyerProductIdentifier` or
        # `vendorProductIdentifier` is required.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # An item's product identifier, which the vendor selects. This identifier should be the same as the identifier,
        # such as a SKU, in the purchase order.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
