# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentInventoryV1
      # The request body for the submitInventoryUpdate operation.
      SubmitInventoryUpdateRequest = Structure.new do
        # Inventory details required to update some or all items for the requested warehouse.
        attribute?(:inventory, InventoryUpdate)
      end
    end
  end
end
