# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The response schema for the `listOrders` operation.
      ListOrdersResponse = Structure.new do
        # @return [Array<FulfillmentOrder>] A list of fulfillment orders.
        attribute(:orders, [FulfillmentOrder], null: false)

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
