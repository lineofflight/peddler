# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrdersV1
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
