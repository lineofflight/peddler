# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/order_item_buyer_info"

module Peddler
  module Types
    module OrdersV0
      # A single order item's buyer information list with the order ID.
      OrderItemsBuyerInfoList = Structure.new do
        # @return [Array<OrderItemBuyerInfo>]
        attribute(:order_items, [OrderItemBuyerInfo], from: "OrderItems")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        # response page.
        attribute?(:next_token, String, from: "NextToken")

        # @return [String] An Amazon-defined order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")
      end
    end
  end
end
