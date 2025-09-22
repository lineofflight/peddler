# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_orders_v1/pagination"
require "peddler/types/vendor_orders_v1/order"

module Peddler
  module Types
    module VendorOrdersV1
      # A list of orders returned as response.
      OrderList = Structure.new do
        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<Order>] Represents an individual order within the OrderList.
        attribute(:orders, [Order])
      end
    end
  end
end
