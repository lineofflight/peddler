# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_inventory_2024_09_11/inventory_response"

module Peddler
  module Types
    module ExternalFulfillmentInventory20240911
      # The response of the `batchInventory` operation.
      BatchInventoryResponse = Structure.new do
        # @return [Array<InventoryResponse>]
        attribute?(:responses, [InventoryResponse])
      end
    end
  end
end
