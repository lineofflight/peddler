# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/orders_v0/error"
require "peddler/types/orders_v0/order"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrder` operation.
      GetOrderResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrder` operation.
        attribute?(:errors, [Error])

        # @return [Order] The payload for the `getOrder` operation.
        attribute?(:payload, Order)
      end
    end
  end
end
