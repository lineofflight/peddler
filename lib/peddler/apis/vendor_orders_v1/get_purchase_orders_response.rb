# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorOrdersV1
      # The response schema for the getPurchaseOrders operation.
      GetPurchaseOrdersResponse = Structure.new do
        attribute?(:errors, [Error])

        # A list of orders.
        attribute?(:payload, OrderList)
      end
    end
  end
end
