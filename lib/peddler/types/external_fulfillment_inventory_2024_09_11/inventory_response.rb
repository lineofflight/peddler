# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_inventory_2024_09_11/inventory_response_body"
require "peddler/types/external_fulfillment_inventory_2024_09_11/http_status_line"

module Peddler
  module Types
    module ExternalFulfillmentInventory20240911
      # A response to an individual inventory request.
      InventoryResponse = Structure.new do
        # @return [InventoryResponseBody] The body of the response.
        attribute(:body, InventoryResponseBody)

        # @return [HttpStatusLine] The HTTP status code associated with the response.
        attribute(:status, HttpStatusLine)
      end
    end
  end
end
