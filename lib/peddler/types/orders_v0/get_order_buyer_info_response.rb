# frozen_string_literal: true

require "peddler/types/orders_v0/order_buyer_info"
require "peddler/types/orders_v0/error"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrderBuyerInfo` operation.
      GetOrderBuyerInfoResponse = Structure.new do
        # @return [OrderBuyerInfo] The payload for the `getOrderBuyerInfo` operation.
        attribute(:payload, OrderBuyerInfo)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderBuyerInfo` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
