# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The request body schema for the `updateOrder` operation.
      UpdateOrderRequest = Structure.new do
        # @return [UpdateOrderFulfillmentConfiguration] Fulfillment configuration to update.
        attribute?(:fulfillment_configuration, UpdateOrderFulfillmentConfiguration, from: "fulfillmentConfiguration")
      end
    end
  end
end
