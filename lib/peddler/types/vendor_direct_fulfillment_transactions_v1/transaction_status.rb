# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_transactions_v1/transaction"

module Peddler
  module Types
    module VendorDirectFulfillmentTransactionsV1
      # The payload for the getTransactionStatus operation.
      TransactionStatus = Structure.new do
        # @return [Transaction]
        attribute?(:transaction_status, Transaction, from: "transactionStatus")
      end
    end
  end
end
