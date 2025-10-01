# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_inventory_2024_09_11/inventory_request"

module Peddler
  module Types
    module ExternalFulfillmentInventory20240911
      # A list of inventory requests.
      BatchInventoryRequest = Structure.new do
        # @return [Array<InventoryRequest>]
        attribute?(:requests, [InventoryRequest])
      end
    end
  end
end
