# frozen_string_literal: true

require "peddler/types/orders_v0/order_items_list"
require "peddler/types/orders_v0/error"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrderItems` operation.
      GetOrderItemsResponse = Structure.new do
        # @return [OrderItemsList] The payload for the `getOrderItems` operation.
        attribute(:payload, OrderItemsList)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderItems` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
