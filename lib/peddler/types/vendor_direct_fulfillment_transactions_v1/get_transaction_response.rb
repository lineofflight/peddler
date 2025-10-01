# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_transactions_v1/error"
require "peddler/types/vendor_direct_fulfillment_transactions_v1/transaction_status"

module Peddler
  module Types
    module VendorDirectFulfillmentTransactionsV1
      # The response schema for the getTransactionStatus operation.
      GetTransactionResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransactionStatus]
        attribute?(:payload, TransactionStatus)
      end
    end
  end
end
