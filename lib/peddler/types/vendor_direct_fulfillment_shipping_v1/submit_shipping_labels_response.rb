# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/transaction_reference"
require "peddler/types/vendor_direct_fulfillment_shipping_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # The response schema for the submitShippingLabelRequest operation.
      SubmitShippingLabelsResponse = Structure.new do
        # @return [TransactionReference] The response payload for the submitShippingLabelRequest operation.
        attribute(:payload, TransactionReference)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
