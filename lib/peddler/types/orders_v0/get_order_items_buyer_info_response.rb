# frozen_string_literal: true

require "peddler/types/orders_v0/order_items_buyer_info_list"
require "peddler/types/orders_v0/error"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrderItemsBuyerInfo` operation.
      GetOrderItemsBuyerInfoResponse = Structure.new do
        # @return [OrderItemsBuyerInfoList] The payload for the `getOrderItemsBuyerInfo` operation.
        attribute(:payload, OrderItemsBuyerInfoList)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderItemsBuyerInfo` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
