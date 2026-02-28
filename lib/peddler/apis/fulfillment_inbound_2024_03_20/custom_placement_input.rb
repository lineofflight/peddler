# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Provide units going to the warehouse.
      CustomPlacementInput = Structure.new do
        # @return [Array<ItemInput>] Items included while creating Inbound Plan.
        attribute(:items, [ItemInput], null: false)

        # @return [String] Warehouse Id.
        attribute(:warehouse_id, String, null: false, from: "warehouseId")
      end
    end
  end
end
