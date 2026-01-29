# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The response schema for the `getOrderFulfillmentInstructions` operation.
      GetOrderFulfillmentInstructionsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderFulfillmentInstructions`
        #   operation.
        attribute?(:errors, [Error])

        # @return [FulfillmentInstructions] The payload for the `getOrderFulfillmentInstructions` operation.
        attribute?(:payload, FulfillmentInstructions)
      end
    end
  end
end
