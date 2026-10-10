# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FBAInventoryV1
      # The object with the list of Inventory to be added
      AddInventoryRequest = Structure.new do
        attribute?(:inventory_items, [InventoryItem], from: "inventoryItems")
      end
    end
  end
end
