# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentInventory20240911
      # The response to an inventory request.
      InventoryResponseBody = Structure.new do
        # @return [Array<ActionableError>] Inventory operation errors that require seller action before retrying the
        # inventory request.
        attribute?(:actionable_errors, [ActionableError], from: "actionableErrors")

        # @return [Integer] Latest sequence number for an inventory update.
        attribute?(:client_sequence_number, Integer, from: "clientSequenceNumber")

        # @return [String] The location where inventory is updated or retrieved.
        attribute?(:location_id, String, from: "locationId")

        # @return [MarketplaceAttributes]
        attribute?(:marketplace_attributes, MarketplaceAttributes, from: "marketplaceAttributes")

        # @return [Integer] The number of items of the specified SKU created in any marketplace that are reserved for
        # shipment and yet to be fulfilled.
        attribute?(:reserved_quantity, Integer, from: "reservedQuantity")

        # @return [Integer] The number of items of the specified SKU that are available for purchase.
        attribute?(:sellable_quantity, Integer, from: "sellableQuantity")

        # @return [String] The SKU ID for which inventory is updated or retrieved
        attribute?(:sku_id, String, from: "skuId")
      end
    end
  end
end
