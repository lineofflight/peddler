# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FBAInventoryAvailabilityChange
      # Notification payload data
      Payload = Structure.new do
        # Amazon Standard Identification Number of the affected inventory item.
        attribute(:asin, String, null: false, from: "ASIN")

        # The Fulfillment Network SKU of the affected inventory item.
        attribute(:fn_sku, String, null: false, from: "FNSKU")

        # List of Fulfillment Inventory Details for each marketplace.
        attribute(:fulfillment_inventory_by_marketplace, Array, null: false, from: "FulfillmentInventoryByMarketplace")

        # Seller SKU of the affected inventory item.
        attribute(:sku, String, null: false, from: "SKU")

        # Selling partner identifier, such as a merchant account, for the affected inventory item.
        attribute(:seller_id, String, null: false, from: "SellerId")
      end
    end
  end
end
