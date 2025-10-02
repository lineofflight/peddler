# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def external_fulfillment_inventory_2024_09_11
      typed? ? APIs::ExternalFulfillmentInventory20240911.typed : APIs::ExternalFulfillmentInventory20240911
    end
  end

  module APIs
    # The Selling Partner API for External Fulfillment Inventory Management
    #
    # You can use the Amazon External Fulfillment Inventory API to manage inventory operations in Amazon's External
    # Fulfillment network, including batch inventory updates and retrievals.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/external-fulfillment/externalFulfillmentInventory_2024-09-11.json
    class ExternalFulfillmentInventory20240911 < API
      class << self
        # Enables typed response parsing
        # @return [self]
        def typed
          @typed = true
          require_relative "../types/external_fulfillment_inventory_2024_09_11"
          self
        end
      end

      # Make up to 10 inventory requests. The response includes the set of responses that correspond to requests. The
      # response for each successful request in the set includes the inventory count for the provided `sku` and
      # `locationId` pair.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] A list of inventory requests.
      # @return [Peddler::Response] The API response
      def batch_inventory(body)
        path = "/externalFulfillment/inventory/2024-09-11/inventories"
        post(path, body:)
      end
    end
  end
end
