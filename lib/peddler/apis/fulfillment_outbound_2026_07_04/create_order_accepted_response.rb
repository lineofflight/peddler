# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The response schema for the `createOrder` operation when the request is accepted for async processing.
      CreateOrderAcceptedResponse = Structure.new do
        # @return [String] The fulfillment order identifier.
        attribute(:order_id, String, null: false, from: "orderId")

        # @return [String] The current status of the fulfillment order.
        attribute(:status, String, null: false)
      end
    end
  end
end
