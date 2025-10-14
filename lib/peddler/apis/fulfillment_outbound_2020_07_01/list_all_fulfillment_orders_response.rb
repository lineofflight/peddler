# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The response schema for the `listAllFulfillmentOrders` operation.
      ListAllFulfillmentOrdersResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `listAllFulfillmentOrders` operation.
        attribute?(:errors, [Error])

        # @return [ListAllFulfillmentOrdersResult] The payload for the `listAllFulfillmentOrders` operation.
        attribute?(:payload, ListAllFulfillmentOrdersResult)
      end
    end
  end
end
