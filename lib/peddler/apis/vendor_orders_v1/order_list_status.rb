# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorOrdersV1
      # A list of order statuses.
      OrderListStatus = Structure.new do
        # @return [Array<OrderStatus>] Represents an order status within the OrderListStatus.
        attribute?(:orders_status, [OrderStatus], from: "ordersStatus")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
