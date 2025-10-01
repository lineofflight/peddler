# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_orders_v1/error"
require "peddler/types/vendor_direct_fulfillment_orders_v1/order_list"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # The response schema for the getOrders operation.
      GetOrdersResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [OrderList] A list of purchase orders.
        attribute?(:payload, OrderList)
      end
    end
  end
end
