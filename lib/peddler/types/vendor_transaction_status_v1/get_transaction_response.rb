# frozen_string_literal: true

require "peddler/types/vendor_transaction_status_v1/transaction_status"
require "peddler/types/vendor_transaction_status_v1/error"

module Peddler
  module Types
    module VendorTransactionStatusV1
      # The response schema for the getTransaction operation.
      GetTransactionResponse = Structure.new do
        # @return [TransactionStatus] The response payload for the getTransaction operation.
        attribute(:payload, TransactionStatus)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
