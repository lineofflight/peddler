# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_orders_v1/order"
require "peddler/types/vendor_orders_v1/pagination"

module Peddler
  module Types
    module VendorOrdersV1
      # A list of orders returned as response.
      OrderList = Structure.new do
        # @return [Array<Order>] Represents an individual order within the OrderList.
        attribute?(:orders, [Order])

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
