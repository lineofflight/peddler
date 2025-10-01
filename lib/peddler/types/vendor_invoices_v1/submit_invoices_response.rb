# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_invoices_v1/error"
require "peddler/types/vendor_invoices_v1/transaction_id"

module Peddler
  module Types
    module VendorInvoicesV1
      # The response schema for the submitInvoices operation.
      SubmitInvoicesResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransactionId] The response payload for the submitInvoices operation.
        attribute?(:payload, TransactionId)
      end
    end
  end
end
