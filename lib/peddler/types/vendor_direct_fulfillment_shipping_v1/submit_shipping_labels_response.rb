# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/transaction_reference"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # The response schema for the submitShippingLabelRequest operation.
      SubmitShippingLabelsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransactionReference] The response payload for the submitShippingLabelRequest operation.
        attribute?(:payload, TransactionReference)
      end
    end
  end
end
