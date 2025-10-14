# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrdersV1
      # The response schema for the getOrder operation.
      GetOrderResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [Order] The payload for the getOrder operation.
        attribute?(:payload, Order)
      end
    end
  end
end
