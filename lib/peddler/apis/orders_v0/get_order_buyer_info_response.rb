# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The response schema for the `getOrderBuyerInfo` operation.
      GetOrderBuyerInfoResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderBuyerInfo` operation.
        attribute?(:errors, [Error])

        # @return [OrderBuyerInfo] The payload for the `getOrderBuyerInfo` operation.
        attribute?(:payload, OrderBuyerInfo)
      end
    end
  end
end
