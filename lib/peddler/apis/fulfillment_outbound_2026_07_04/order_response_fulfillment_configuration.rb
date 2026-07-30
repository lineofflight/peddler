# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Fulfillment configuration in order response.
      OrderResponseFulfillmentConfiguration = Structure.new do
        # @return [String] Specifies whether the fulfillment order should ship now or have an order hold put on it.
        attribute?(:action, String)

        # @return [String] The policy for the fulfillment order.
        attribute?(:policy, String)

        # @return [ServiceLevel] Set of service settings that indicate the service contract for an order or item.
        attribute?(:service_level, ServiceLevel, from: "serviceLevel")

        # @return [OrderServices] Services for the order.
        attribute?(:services, OrderServices)
      end
    end
  end
end
