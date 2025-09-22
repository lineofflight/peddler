# frozen_string_literal: true

require "peddler/types/money"
require "peddler/types/vendor_shipments_v1/item_quantity"

module Peddler
  module Types
    module VendorShipmentsV1
      # Details of the item being shipped.
      PurchaseOrderItems = Structure.new do
        # @return [String] Item sequence number for the item. The first item will be 001, the second 002, and so on.
        # This number is used as a reference to refer to this item from the carton or pallet level.
        attribute(:item_sequence_number, String, from: "itemSequenceNumber")

        # @return [String] Amazon Standard Identification Number (ASIN) for a SKU
        attribute(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] The vendor selected product identification of the item. Should be the same as was sent in the
        # purchase order.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [ItemQuantity] Total item quantity shipped in this shipment.
        attribute(:shipped_quantity, ItemQuantity, from: "shippedQuantity")

        # @return [Types::Money]
        attribute(:maximum_retail_price, Types::Money, from: "maximumRetailPrice")
      end
    end
  end
end
