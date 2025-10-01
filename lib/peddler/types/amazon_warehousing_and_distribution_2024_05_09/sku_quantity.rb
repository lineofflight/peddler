# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/inventory_quantity"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Quantity details for a SKU as part of a shipment
      SkuQuantity = Structure.new do
        # @return [InventoryQuantity]
        attribute(:expected_quantity, InventoryQuantity, from: "expectedQuantity")

        # @return [String] The merchant stock keeping unit
        attribute(:sku, String)

        # @return [InventoryQuantity]
        attribute?(:received_quantity, InventoryQuantity, from: "receivedQuantity")
      end
    end
  end
end
