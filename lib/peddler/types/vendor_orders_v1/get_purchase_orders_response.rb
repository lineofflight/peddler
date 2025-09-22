# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_orders_v1/order_list"
require "peddler/types/vendor_orders_v1/error"

module Peddler
  module Types
    module VendorOrdersV1
      # The response schema for the getPurchaseOrders operation.
      GetPurchaseOrdersResponse = Structure.new do
        # @return [OrderList] A list of orders.
        attribute(:payload, OrderList)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
