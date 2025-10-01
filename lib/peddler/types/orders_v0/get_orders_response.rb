# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/orders_v0/error"
require "peddler/types/orders_v0/orders_list"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrders` operation.
      GetOrdersResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrders` operation.
        attribute?(:errors, [Error])

        # @return [OrdersList] The payload for the `getOrders` operation.
        attribute?(:payload, OrdersList)
      end
    end
  end
end
