# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for External Fulfillment Inventory Management
    #
    # You can use the Amazon External Fulfillment Inventory API to manage inventory operations in Amazon's External
    # Fulfillment network, including batch inventory updates and retrievals.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/external-fulfillment/externalFulfillmentInventory_2024-09-11.json
    module ExternalFulfillmentInventory20240911
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "external_fulfillment_inventory_2024_09_11.batch_inventory" => -> { BatchInventoryResponse },
      })
    end
  end
end
