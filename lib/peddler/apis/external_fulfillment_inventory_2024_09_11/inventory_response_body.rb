# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentInventory20240911
      # The response to an inventory request.
      InventoryResponseBody = Structure.new do
        # Inventory operation errors that require seller action before retrying the inventory request.
        attribute?(:actionable_errors, [ActionableError], from: "actionableErrors")

        # Latest sequence number for an inventory update.
        attribute?(:client_sequence_number, Integer, from: "clientSequenceNumber")

        # The location where inventory is updated or retrieved.
        attribute?(:location_id, String, from: "locationId")

        attribute?(:marketplace_attributes, MarketplaceAttributes, from: "marketplaceAttributes")

        # The number of items of the specified SKU created in any marketplace that are reserved for shipment and yet to
        # be fulfilled.
        attribute?(:reserved_quantity, Integer, from: "reservedQuantity")

        # The number of items of the specified SKU that are available for purchase.
        attribute?(:sellable_quantity, Integer, from: "sellableQuantity")

        # The SKU ID for which inventory is updated or retrieved
        attribute?(:sku_id, String, from: "skuId")
      end
    end
  end
end
