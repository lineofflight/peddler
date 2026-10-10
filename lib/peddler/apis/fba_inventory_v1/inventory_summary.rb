# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FBAInventoryV1
      # Inventory summary for a specific item.
      InventorySummary = Structure.new do
        # The Amazon Standard Identification Number (ASIN) of an item.
        attribute?(:asin, String)

        # The condition of the item as described by the seller (for example, New Item).
        attribute?(:condition, String)

        # Amazon's fulfillment network SKU identifier.
        attribute?(:fn_sku, String, from: "fnSku")

        attribute?(:inventory_details, InventoryDetails, from: "inventoryDetails")

        # The date and time that any quantity was last updated.
        attribute?(:last_updated_time, Time, from: "lastUpdatedTime")

        # The localized language product title of the item within the specific marketplace.
        attribute?(:product_name, String, from: "productName")

        # The seller SKU of the item.
        attribute?(:seller_sku, String, from: "sellerSku")

        # A list of seller-enrolled stores that apply to this seller SKU.
        attribute?(:stores, [String])

        # The total number of units in an inbound shipment or in Amazon fulfillment centers.
        attribute?(:total_quantity, Integer, from: "totalQuantity")
      end
    end
  end
end
