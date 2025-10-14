# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrders20211228
      # A list of purchase orders.
      OrderList = Structure.new do
        # @return [Array<Order>] Represents a purchase order within the OrderList.
        attribute?(:orders, [Order])

        # @return [Pagination] The pagination elements required to retrieve the remaining data.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
