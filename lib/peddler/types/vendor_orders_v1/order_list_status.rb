# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_orders_v1/pagination"
require "peddler/types/vendor_orders_v1/order_status"

module Peddler
  module Types
    module VendorOrdersV1
      # A list of order statuses.
      OrderListStatus = Structure.new do
        # @return [Pagination]
        attribute?(:pagination, Pagination)

        # @return [Array<OrderStatus>] Represents an order status within the OrderListStatus.
        attribute?(:orders_status, [OrderStatus], from: "ordersStatus")
      end
    end
  end
end
