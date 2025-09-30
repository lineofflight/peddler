# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_invoices_v1/transaction_id"
require "peddler/types/vendor_invoices_v1/error"

module Peddler
  module Types
    module VendorInvoicesV1
      # The response schema for the submitInvoices operation.
      SubmitInvoicesResponse = Structure.new do
        # @return [TransactionId] The response payload for the submitInvoices operation.
        attribute?(:payload, TransactionId)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
