# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Summary of inventory per SKU.
      InventorySummary = Structure.new do
        # The seller or merchant SKU.
        attribute(:sku, String, null: false)

        # The expiration details of the inventory. This object will only appear if the `details` parameter in the
        # request is set to `SHOW`.
        attribute?(:expiration_details, [ExpirationDetails], from: "expirationDetails")

        attribute?(:inventory_details, InventoryDetails, from: "inventoryDetails")

        # Total quantity that is in-transit from the seller and has not yet been received at an AWD Distribution Center
        attribute?(:total_inbound_quantity, Integer, from: "totalInboundQuantity")

        # Total quantity that is present in AWD distribution centers.
        attribute?(:total_onhand_quantity, Integer, from: "totalOnhandQuantity")
      end
    end
  end
end
