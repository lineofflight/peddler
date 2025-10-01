# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_inventory_v1/inventory_update"

module Peddler
  module Types
    module VendorDirectFulfillmentInventoryV1
      # The request body for the submitInventoryUpdate operation.
      SubmitInventoryUpdateRequest = Structure.new do
        # @return [InventoryUpdate] Inventory details required to update some or all items for the requested warehouse.
        attribute?(:inventory, InventoryUpdate)
      end
    end
  end
end
