# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/item_quantity"
require "peddler/types/vendor_shipments_v1/item_details"

module Peddler
  module Types
    module VendorShipmentsV1
      # Carton/Pallet level details for the item.
      ContainerItem = Structure.new do
        # @return [String] The reference number for the item. Please provide the itemSequenceNumber from the 'items'
        # segment to refer to that item's details here.
        attribute(:item_reference, String, from: "itemReference")

        # @return [ItemQuantity] Total item quantity shipped in this carton/pallet.
        attribute(:shipped_quantity, ItemQuantity, from: "shippedQuantity")

        # @return [ItemDetails]
        attribute(:item_details, ItemDetails, from: "itemDetails")
      end
    end
  end
end
