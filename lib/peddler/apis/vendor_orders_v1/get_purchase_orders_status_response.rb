# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorOrdersV1
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
