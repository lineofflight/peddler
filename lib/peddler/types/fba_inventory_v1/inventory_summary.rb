# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fba_inventory_v1/inventory_details"

module Peddler
  module Types
    module FBAInventoryV1
      # Inventory summary for a specific item.
      InventorySummary = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of an item.
        attribute?(:asin, String)

        # @return [String] Amazon's fulfillment network SKU identifier.
        attribute?(:fn_sku, String, from: "fnSku")

        # @return [String] The seller SKU of the item.
        attribute?(:seller_sku, String, from: "sellerSku")

        # @return [String] The condition of the item as described by the seller (for example, New Item).
        attribute?(:condition, String)

        # @return [InventoryDetails]
        attribute?(:inventory_details, InventoryDetails, from: "inventoryDetails")

        # @return [String] The date and time that any quantity was last updated.
        attribute?(:last_updated_time, String, from: "lastUpdatedTime")

        # @return [String] The localized language product title of the item within the specific marketplace.
        attribute?(:product_name, String, from: "productName")

        # @return [Integer] The total number of units in an inbound shipment or in Amazon fulfillment centers.
        attribute?(:total_quantity, Integer, from: "totalQuantity")

        # @return [Array<String>] A list of seller-enrolled stores that apply to this seller SKU.
        attribute?(:stores, [String])
      end
    end
  end
end
