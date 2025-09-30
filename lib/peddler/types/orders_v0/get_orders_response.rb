# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/orders_list"
require "peddler/types/orders_v0/error"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrders` operation.
      GetOrdersResponse = Structure.new do
        # @return [OrdersList] The payload for the `getOrders` operation.
        attribute?(:payload, OrdersList)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrders` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
