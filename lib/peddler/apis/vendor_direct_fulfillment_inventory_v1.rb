# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def vendor_direct_fulfillment_inventory_v1(...)
      APIs::VendorDirectFulfillmentInventoryV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for Direct Fulfillment Inventory Updates
    #
    # The Selling Partner API for Direct Fulfillment Inventory Updates provides programmatic access to a direct
    # fulfillment vendor's inventory updates.
    class VendorDirectFulfillmentInventoryV1 < API
      # Submits inventory updates for the specified warehouse for either a partial or full feed of inventory items.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body containing the inventory update data to submit.
      # @param warehouse_id [String] Identifier for the warehouse for which to update inventory.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def submit_inventory_update(body, warehouse_id, rate_limit: 10.0, tries: 2)
        path = "/vendor/directFulfillment/inventory/v1/warehouses/#{warehouse_id}/items"

        meter(rate_limit, tries:).post(path, body:)
      end
    end
  end
end
