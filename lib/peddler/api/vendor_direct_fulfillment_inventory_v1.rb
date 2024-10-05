# frozen_string_literal: true

require "peddler/api"
require "peddler/marketplace"

module Peddler
  class << self
    def vendor_direct_fulfillment_inventory_v1(...)
      API::VendorDirectFulfillmentInventoryV1.new(...)
    end
  end

  class API
    # Selling Partner API for Direct Fulfillment Inventory Updates
    #
    # The Selling Partner API for Direct Fulfillment Inventory Updates provides programmatic access to a direct
    # fulfillment vendor's inventory updates.
    class VendorDirectFulfillmentInventoryV1 < API
      # Submits inventory updates for the specified warehouse for either a partial or full feed of inventory items.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body that contains the inventory update data to submit.
      # @param warehouse_id [String] Identifier for the warehouse for which to update inventory.
      # @param rate_limit [Float] Requests per second
      # @return [Hash] The API response
      def submit_inventory_update(body, warehouse_id, rate_limit: 10.0)
        path = "/vendor/directFulfillment/inventory/v1/warehouses/#{warehouse_id}/items"

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
