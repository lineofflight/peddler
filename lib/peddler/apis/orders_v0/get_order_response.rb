# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # The response schema for the `getOrder` operation.
      GetOrderResponse = Structure.new do
        # One or more unexpected errors occurred during the `getOrder` operation.
        attribute?(:errors, [Error])

        # The payload for the `getOrder` operation.
        attribute?(:payload, Order)
      end
    end
  end
end
