# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_inventory_v1/party_identification"
require "peddler/types/vendor_direct_fulfillment_inventory_v1/item_details"

module Peddler
  module Types
    module VendorDirectFulfillmentInventoryV1
      # Inventory details required to update some or all items for the requested warehouse.
      InventoryUpdate = Structure.new do
        # @return [PartyIdentification] ID of the selling party or vendor.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [:boolean] When true, this request contains a full feed. Otherwise, this request contains a partial
        # feed. When sending a full feed, you must send information about all items in the warehouse. Any items not in
        # the full feed are updated as not available. When sending a partial feed, only include the items that need an
        # update to inventory. The status of other items will remain unchanged.
        attribute(:full_update, :boolean, from: "isFullUpdate")

        # @return [Array<ItemDetails>] A list of inventory items with updated details, including quantity available.
        attribute(:items, [ItemDetails])
      end
    end
  end
end
