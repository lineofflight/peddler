# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The response schema for the directPurchaseShipment operation.
      DirectPurchaseResponse = Structure.new do
        # @return [DirectPurchaseResult]
        attribute?(:payload, DirectPurchaseResult)
      end
    end
  end
end
