# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_inventory_2024_09_11/marketplace_attributes"

module Peddler
  module Types
    module ExternalFulfillmentInventory20240911
      # The parameters for an individual request.
      InventoryRequestParams = Structure.new do
        # @return [Integer] The latest sequence number for the inventory update operation. You find this value in the
        # `clientSequenceNumber` property in the response to the `batchInventory` operation.
        attribute?(:client_sequence_number, Integer, from: "clientSequenceNumber")

        # @return [MarketplaceAttributes]
        attribute?(:marketplace_attributes, MarketplaceAttributes, from: "marketplaceAttributes")

        # @return [Integer] The absolute inventory quantity.
        attribute?(:quantity, Integer)
      end
    end
  end
end
