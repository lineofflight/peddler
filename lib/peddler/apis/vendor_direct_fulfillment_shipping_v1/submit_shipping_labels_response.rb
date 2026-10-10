# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShippingV1
      # The response schema for the submitShippingLabelRequest operation.
      SubmitShippingLabelsResponse = Structure.new do
        attribute?(:errors, [Error])

        # The response payload for the submitShippingLabelRequest operation.
        attribute?(:payload, TransactionReference)
      end
    end
  end
end
