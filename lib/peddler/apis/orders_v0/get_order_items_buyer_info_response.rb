# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # The response schema for the `getOrderItemsBuyerInfo` operation.
      GetOrderItemsBuyerInfoResponse = Structure.new do
        # One or more unexpected errors occurred during the `getOrderItemsBuyerInfo` operation.
        attribute?(:errors, [Error])

        # The payload for the `getOrderItemsBuyerInfo` operation.
        attribute?(:payload, OrderItemsBuyerInfoList)
      end
    end
  end
end
