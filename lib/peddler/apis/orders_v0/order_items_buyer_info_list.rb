# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # A single order item's buyer information list with the order ID.
      OrderItemsBuyerInfoList = Structure.new do
        # @return [String] An Amazon-defined order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, null: false, from: "AmazonOrderId")

        # @return [Array<OrderItemBuyerInfo>]
        attribute(:order_items, [OrderItemBuyerInfo], null: false, from: "OrderItems")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        #   response page.
        attribute?(:next_token, String, from: "NextToken")
      end
    end
  end
end
