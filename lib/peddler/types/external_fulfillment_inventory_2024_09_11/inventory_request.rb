# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_inventory_2024_09_11/inventory_request_params"

module Peddler
  module Types
    module ExternalFulfillmentInventory20240911
      # An inventory request.
      InventoryRequest = Structure.new do
        # @return [String] The method associated with the individual operation from the batch request. To make an
        # update, use `POST`.
        attribute(:method, String)

        # @return [String] The URI associated with the individual APIs from the batch request. The user must provide the
        # resource identifier for the operation they want to use.
        attribute(:uri, String)

        # @return [InventoryRequestParams] The body associated with the individual APIs being called as part of the
        # batch request.
        attribute?(:body, InventoryRequestParams)
      end
    end
  end
end
