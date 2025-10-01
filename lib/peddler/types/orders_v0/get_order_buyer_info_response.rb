# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/orders_v0/error"
require "peddler/types/orders_v0/order_buyer_info"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrderBuyerInfo` operation.
      GetOrderBuyerInfoResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderBuyerInfo` operation.
        attribute?(:errors, [Error])

        # @return [OrderBuyerInfo] The payload for the `getOrderBuyerInfo` operation.
        attribute?(:payload, OrderBuyerInfo)
      end
    end
  end
end
