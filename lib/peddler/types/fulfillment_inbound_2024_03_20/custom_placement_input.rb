# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/item_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Provide units going to the warehouse.
      CustomPlacementInput = Structure.new do
        # @return [Array<ItemInput>] Items included while creating Inbound Plan.
        attribute(:items, [ItemInput])

        # @return [String] Warehouse Id.
        attribute(:warehouse_id, String, from: "warehouseId")
      end
    end
  end
end
