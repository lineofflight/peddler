# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The request body schema for the `updateOrderStatus` operation.
      UpdateOrderStatusRequest = Structure.new do
        # @return [String] The status of the fulfillment order to apply.
        attribute(:status, String, null: false)
      end
    end
  end
end
