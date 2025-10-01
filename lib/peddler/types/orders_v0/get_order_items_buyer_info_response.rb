# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/orders_v0/error"
require "peddler/types/orders_v0/order_items_buyer_info_list"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrderItemsBuyerInfo` operation.
      GetOrderItemsBuyerInfoResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderItemsBuyerInfo` operation.
        attribute?(:errors, [Error])

        # @return [OrderItemsBuyerInfoList] The payload for the `getOrderItemsBuyerInfo` operation.
        attribute?(:payload, OrderItemsBuyerInfoList)
      end
    end
  end
end
