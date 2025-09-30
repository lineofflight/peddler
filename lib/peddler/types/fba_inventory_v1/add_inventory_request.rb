# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fba_inventory_v1/inventory_item"

module Peddler
  module Types
    module FBAInventoryV1
      # The object with the list of Inventory to be added
      AddInventoryRequest = Structure.new do
        # @return [Array<InventoryItem>]
        attribute?(:inventory_items, [InventoryItem], from: "inventoryItems")
      end
    end
  end
end
