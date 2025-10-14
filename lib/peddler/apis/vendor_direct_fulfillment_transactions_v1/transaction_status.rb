# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentTransactionsV1
      # The payload for the getTransactionStatus operation.
      TransactionStatus = Structure.new do
        # @return [Transaction]
        attribute?(:transaction_status, Transaction, from: "transactionStatus")
      end
    end
  end
end
