# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/order"
require "peddler/types/orders_v0/error"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrder` operation.
      GetOrderResponse = Structure.new do
        # @return [Order] The payload for the `getOrder` operation.
        attribute?(:payload, Order)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrder` operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
