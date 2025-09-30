# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_payments_v1/transaction_reference"
require "peddler/types/vendor_direct_fulfillment_payments_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentPaymentsV1
      # The response schema for the submitInvoice operation.
      SubmitInvoiceResponse = Structure.new do
        # @return [TransactionReference] The response payload for the submitInvoice operation.
        attribute?(:payload, TransactionReference)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
