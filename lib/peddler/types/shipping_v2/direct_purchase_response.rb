# frozen_string_literal: true

require "peddler/types/shipping_v2/direct_purchase_result"

module Peddler
  module Types
    module ShippingV2
      # The response schema for the directPurchaseShipment operation.
      DirectPurchaseResponse = Structure.new do
        # @return [DirectPurchaseResult]
        attribute(:payload, DirectPurchaseResult)
      end
    end
  end
end
