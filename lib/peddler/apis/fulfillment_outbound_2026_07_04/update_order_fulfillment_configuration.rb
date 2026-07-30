# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Fulfillment configuration for update order request. Only action can be updated.
      UpdateOrderFulfillmentConfiguration = Structure.new do
        # @return [String] Specifies whether the fulfillment order should ship now or have an order hold put on it.
        attribute?(:action, String)
      end
    end
  end
end
