# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_orders_v1/order_list"
require "peddler/types/vendor_direct_fulfillment_orders_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # The response schema for the getOrders operation.
      GetOrdersResponse = Structure.new do
        # @return [OrderList] A list of purchase orders.
        attribute(:payload, OrderList)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
