# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/order_address"
require "peddler/types/orders_v0/error"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrderAddress` operation.
      GetOrderAddressResponse = Structure.new do
        # @return [OrderAddress] The payload for the `getOrderAddress` operations.
        attribute(:payload, OrderAddress)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderAddress` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
