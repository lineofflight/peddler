# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/error"
require "peddler/types/shipping_v1/purchase_labels_result"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the purchaseLabels operation.
      PurchaseLabelsResponse = Structure.new do
        # @return [Array<Error>] Encountered errors for the operation.
        attribute?(:errors, [Error])

        # @return [PurchaseLabelsResult] The payload for purchaseLabels operation
        attribute?(:payload, PurchaseLabelsResult)
      end
    end
  end
end
