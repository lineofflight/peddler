# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/purchase_labels_result"
require "peddler/types/shipping_v1/error"

module Peddler
  module Types
    module ShippingV1
      # The response schema for the purchaseLabels operation.
      PurchaseLabelsResponse = Structure.new do
        # @return [PurchaseLabelsResult] The payload for purchaseLabels operation
        attribute(:payload, PurchaseLabelsResult)

        # @return [Array<Error>] Encountered errors for the operation.
        attribute(:errors, [Error])
      end
    end
  end
end
