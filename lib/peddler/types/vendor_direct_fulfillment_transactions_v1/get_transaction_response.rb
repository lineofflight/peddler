# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_transactions_v1/transaction_status"
require "peddler/types/vendor_direct_fulfillment_transactions_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentTransactionsV1
      # The response schema for the getTransactionStatus operation.
      GetTransactionResponse = Structure.new do
        # @return [TransactionStatus]
        attribute(:payload, TransactionStatus)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
