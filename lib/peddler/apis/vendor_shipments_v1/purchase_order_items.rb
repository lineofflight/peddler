# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Details of the item being shipped.
      PurchaseOrderItems = Structure.new do
        # @return [String] Item sequence number for the item. The first item will be 001, the second 002, and so on.
        #   This number is used as a reference to refer to this item from the carton or pallet level.
        attribute(:item_sequence_number, String, null: false, from: "itemSequenceNumber")

        # @return [ItemQuantity] Total item quantity shipped in this shipment.
        attribute(:shipped_quantity, ItemQuantity, null: false, from: "shippedQuantity")

        # @return [String] Amazon Standard Identification Number (ASIN) for a SKU
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [Money]
        attribute?(:maximum_retail_price, Money, from: "maximumRetailPrice")

        # @return [String] The vendor selected product identification of the item. Should be the same as was sent in the
        #   purchase order.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
