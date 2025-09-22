# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/order_regulated_info"
require "peddler/types/orders_v0/error"

module Peddler
  module Types
    module OrdersV0
      # The response schema for the `getOrderRegulatedInfo` operation.
      GetOrderRegulatedInfoResponse = Structure.new do
        # @return [OrderRegulatedInfo] The payload for the `getOrderRegulatedInfo` operation.
        attribute(:payload, OrderRegulatedInfo)

        # @return [Array<Error>] One or more unexpected errors occurred during the `getOrderRegulatedInfo` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
