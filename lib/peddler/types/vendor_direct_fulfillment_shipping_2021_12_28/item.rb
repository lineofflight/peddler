# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/item_quantity"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Details of the item being shipped.
      Item = Structure.new do
        # @return [Integer] The sequence number of the item. The number must be the same as the order number of the
        # item.
        attribute(:item_sequence_number, Integer, from: "itemSequenceNumber")

        # @return [String] The buyer's Amazon Standard Identification Number (ASIN) of an item. Either
        # `buyerProductIdentifier` or `vendorProductIdentifier` is required.
        attribute(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] An item's product identifier, which the vendor selects. This identifier should be the same as
        # the identifier, such as a SKU, in the purchase order.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [ItemQuantity] The total quantity of items that are in this shipment.
        attribute(:shipped_quantity, ItemQuantity, from: "shippedQuantity")
      end
    end
  end
end
