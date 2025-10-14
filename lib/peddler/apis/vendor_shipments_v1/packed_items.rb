# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Details of the item being shipped.
      PackedItems = Structure.new do
        # @return [String] Buyer Standard Identification Number (ASIN) of an item.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [PackageItemDetails]
        attribute?(:item_details, PackageItemDetails, from: "itemDetails")

        # @return [String] Item sequence number for the item. The first item will be 001, the second 002, and so on.
        # This number is used as a reference to refer to this item from the carton or pallet level.
        attribute?(:item_sequence_number, String, from: "itemSequenceNumber")

        # @return [ItemQuantity] Total item quantity shipped in this shipment.
        attribute?(:packed_quantity, ItemQuantity, from: "packedQuantity")

        # @return [String] The vendor selected product identification of the item. Should be the same as was sent in the
        # purchase order.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
