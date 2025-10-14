# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentInventory20240911
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
