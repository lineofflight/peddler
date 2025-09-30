# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_transaction_status_v1/transaction"

module Peddler
  module Types
    module VendorTransactionStatusV1
      # Represents the status of a transaction.
      TransactionStatus = Structure.new do
        # @return [Transaction]
        attribute?(:transaction_status, Transaction, from: "transactionStatus")
      end
    end
  end
end
