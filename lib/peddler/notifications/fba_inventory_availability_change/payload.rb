# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FBAInventoryAvailabilityChange
      # Notification payload data
      Payload = Structure.new do
        # @return [String] Amazon Standard Identification Number of the affected inventory item.
        attribute(:asin, String, from: "ASIN")

        # @return [String] The Fulfillment Network SKU of the affected inventory item.
        attribute(:fn_sku, String, from: "FNSKU")

        # @return [Array<Object>] List of Fulfillment Inventory Details for each marketplace.
        attribute(:fulfillment_inventory_by_marketplace, Array, from: "FulfillmentInventoryByMarketplace")

        # @return [String] Seller SKU of the affected inventory item.
        attribute(:sku, String, from: "SKU")

        # @return [String] Selling partner identifier, such as a merchant account, for the affected inventory item.
        attribute(:seller_id, String, from: "SellerId")
      end
    end
  end
end
