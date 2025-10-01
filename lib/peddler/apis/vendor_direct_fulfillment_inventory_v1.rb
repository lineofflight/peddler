# frozen_string_literal: true

# This file is generated. Edit template if necessary.

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
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-inventory-api-model/vendorDirectFulfillmentInventoryV1.json
    class VendorDirectFulfillmentInventoryV1 < API
      # Submits inventory updates for the specified warehouse for either a partial or full feed of inventory items.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body containing the inventory update data to submit.
      # @param warehouse_id [String] Identifier for the warehouse for which to update inventory.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_inventory_update(body, warehouse_id, rate_limit: 10.0)
        path = "/vendor/directFulfillment/inventory/v1/warehouses/#{percent_encode(warehouse_id)}/items"
        parser = Peddler::Types::VendorDirectFulfillmentInventoryV1::SubmitInventoryUpdateResponse if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      private

      def load_types
        require "peddler/types/vendor_direct_fulfillment_inventory_v1"
      end
    end
  end
end
