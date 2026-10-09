# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Inventory Updates
    #
    # The Selling Partner API for Direct Fulfillment Inventory Updates provides programmatic access to a direct
    # fulfillment vendor's inventory updates.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-inventory-api-model/vendorDirectFulfillmentInventoryV1.json
    module VendorDirectFulfillmentInventoryV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "vendor_direct_fulfillment_inventory_v1.submit_inventory_update" => -> { SubmitInventoryUpdateResponse },
      })
    end
  end
end
