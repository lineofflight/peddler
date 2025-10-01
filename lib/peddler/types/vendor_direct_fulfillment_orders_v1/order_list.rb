# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_orders_v1/order"
require "peddler/types/vendor_direct_fulfillment_orders_v1/pagination"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # A list of purchase orders returned as response.
      OrderList = Structure.new do
        # @return [Array<Order>] Represents a purchase order within the OrderList.
        attribute?(:orders, [Order])

        # @return [Pagination] The pagination elements required to retrieve the remaining data.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
