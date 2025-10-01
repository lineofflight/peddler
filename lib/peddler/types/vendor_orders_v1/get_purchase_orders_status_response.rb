# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_orders_v1/error"
require "peddler/types/vendor_orders_v1/order_list_status"

module Peddler
  module Types
    module VendorOrdersV1
      # The response schema for the getPurchaseOrdersStatus operation.
      GetPurchaseOrdersStatusResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [OrderListStatus] Current status of list of purchase orders.
        attribute?(:payload, OrderListStatus)
      end
    end
  end
end
