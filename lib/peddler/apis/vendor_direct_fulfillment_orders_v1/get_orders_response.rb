# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentOrdersV1
      # The response schema for the getOrders operation.
      GetOrdersResponse = Structure.new do
        attribute?(:errors, [Error])

        # A list of purchase orders.
        attribute?(:payload, OrderList)
      end
    end
  end
end
