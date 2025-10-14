# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The response schema for the purchaseShipment operation.
      PurchaseShipmentResponse = Structure.new do
        # @return [PurchaseShipmentResult]
        attribute?(:payload, PurchaseShipmentResult)
      end
    end
  end
end
