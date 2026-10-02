# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for FBA Inventory
    #
    # The Selling Partner API for FBA Inventory lets you programmatically retrieve information about inventory in
    # Amazon's fulfillment network.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/fba-inventory-api-model/fbaInventory.json
    module FBAInventoryV1
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "fba_inventory_v1.add_inventory" => -> { AddInventoryResponse },
        "fba_inventory_v1.create_inventory_item" => -> { CreateInventoryItemResponse },
        "fba_inventory_v1.delete_inventory_item" => -> { DeleteInventoryItemResponse },
        "fba_inventory_v1.get_inventory_summaries" => -> { GetInventorySummariesResponse },
      }.freeze
    end
  end
end
