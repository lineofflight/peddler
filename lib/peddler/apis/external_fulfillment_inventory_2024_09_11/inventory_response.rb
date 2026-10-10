# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentInventory20240911
      # A response to an individual inventory request.
      InventoryResponse = Structure.new do
        # The body of the response.
        attribute(:body, InventoryResponseBody, null: false)

        # The HTTP status code associated with the response.
        attribute(:status, HttpStatusLine, null: false)
      end
    end
  end
end
