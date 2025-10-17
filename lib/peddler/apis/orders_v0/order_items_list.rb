# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The order items list along with the order ID.
      OrderItemsList = Structure.new do
        # @return [String] An Amazon-defined order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [Array<OrderItem>]
        attribute(:order_items, [OrderItem], from: "OrderItems")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        #   response page.
        attribute?(:next_token, String, from: "NextToken")
      end
    end
  end
end
