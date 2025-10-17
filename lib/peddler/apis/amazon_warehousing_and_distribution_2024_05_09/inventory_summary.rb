# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Summary of inventory per SKU.
      InventorySummary = Structure.new do
        # @return [String] The seller or merchant SKU.
        attribute(:sku, String)

        # @return [Array<ExpirationDetails>] The expiration details of the inventory. This object will only appear if
        #   the `details` parameter in the request is set to `SHOW`.
        attribute?(:expiration_details, [ExpirationDetails], from: "expirationDetails")

        # @return [InventoryDetails]
        attribute?(:inventory_details, InventoryDetails, from: "inventoryDetails")

        # @return [Integer] Total quantity that is in-transit from the seller and has not yet been received at an AWD
        #   Distribution Center
        attribute?(:total_inbound_quantity, Integer, from: "totalInboundQuantity")

        # @return [Integer] Total quantity that is present in AWD distribution centers.
        attribute?(:total_onhand_quantity, Integer, from: "totalOnhandQuantity")
      end
    end
  end
end
