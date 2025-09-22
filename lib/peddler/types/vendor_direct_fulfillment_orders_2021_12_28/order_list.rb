# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/pagination"
require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/order"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # A list of purchase orders.
      OrderList = Structure.new do
        # @return [Pagination] The pagination elements required to retrieve the remaining data.
        attribute(:pagination, Pagination)

        # @return [Array<Order>] Represents a purchase order within the OrderList.
        attribute(:orders, [Order])
      end
    end
  end
end
