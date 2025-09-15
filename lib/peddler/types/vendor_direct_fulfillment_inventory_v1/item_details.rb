# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_inventory_v1/item_quantity"

module Peddler
  module Types
    module VendorDirectFulfillmentInventoryV1
      # Updated inventory details for an item.
      ItemDetails = Structure.new do
        # @return [String] The buyer selected product identification of the item. Either buyerProductIdentifier or
        # vendorProductIdentifier should be submitted.
        attribute(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] The vendor selected product identification of the item. Either buyerProductIdentifier or
        # vendorProductIdentifier should be submitted.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [ItemQuantity] Total item quantity available in the warehouse.
        attribute(:available_quantity, ItemQuantity, from: "availableQuantity")

        # @return [:boolean] When true, the item is permanently unavailable.
        attribute(:obsolete, :boolean, from: "isObsolete")
      end
    end
  end
end
