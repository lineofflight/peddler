# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # Carton/Pallet level details for the item.
      ContainerItem = Structure.new do
        # The reference number for the item. Please provide the itemSequenceNumber from the 'items' segment to refer to
        # that item's details here.
        attribute(:item_reference, String, null: false, from: "itemReference")

        # Total item quantity shipped in this carton/pallet.
        attribute(:shipped_quantity, ItemQuantity, null: false, from: "shippedQuantity")

        attribute?(:item_details, ItemDetails, from: "itemDetails")
      end
    end
  end
end
