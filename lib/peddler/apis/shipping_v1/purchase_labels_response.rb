# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The response schema for the purchaseLabels operation.
      PurchaseLabelsResponse = Structure.new do
        # Encountered errors for the operation.
        attribute?(:errors, [Error])

        # The payload for purchaseLabels operation
        attribute?(:payload, PurchaseLabelsResult)
      end
    end
  end
end
