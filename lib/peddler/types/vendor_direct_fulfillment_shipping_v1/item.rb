# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/item_quantity"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Details of the item being shipped.
      Item = Structure.new do
        # @return [Integer] Item Sequence Number for the item. This must be the same value as sent in order for a given
        # item.
        attribute(:item_sequence_number, Integer, from: "itemSequenceNumber")

        # @return [String] Buyer's Standard Identification Number (ASIN) of an item. Either buyerProductIdentifier or
        # vendorProductIdentifier is required.
        attribute(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] The vendor selected product identification of the item. Should be the same as was sent in the
        # purchase order, like SKU Number.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [ItemQuantity] Total item quantity shipped in this shipment.
        attribute(:shipped_quantity, ItemQuantity, from: "shippedQuantity")
      end
    end
  end
end
