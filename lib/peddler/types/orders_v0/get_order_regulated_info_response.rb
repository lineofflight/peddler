# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/orders_v0/error"
require "peddler/types/orders_v0/order_regulated_info"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrderRegulatedInfo` operation.
      GetOrderRegulatedInfoResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderRegulatedInfo` operation.
        attribute?(:errors, [Error])

        # @return [OrderRegulatedInfo] The payload for the `getOrderRegulatedInfo` operation.
        attribute?(:payload, OrderRegulatedInfo)
      end
    end
  end
end
