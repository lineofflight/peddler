# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The response schema for the `getOrderItems` operation.
      GetOrderItemsResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderItems` operation.
        attribute?(:errors, [Error])

        # @return [OrderItemsList] The payload for the `getOrderItems` operation.
        attribute?(:payload, OrderItemsList)
      end
    end
  end
end
