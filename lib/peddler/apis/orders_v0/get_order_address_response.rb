# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The response schema for the `getOrderAddress` operation.
      GetOrderAddressResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderAddress` operation.
        attribute?(:errors, [Error])

        # @return [OrderAddress] The payload for the `getOrderAddress` operations.
        attribute?(:payload, OrderAddress)
      end
    end
  end
end
