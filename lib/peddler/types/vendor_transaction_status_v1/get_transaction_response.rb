# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_transaction_status_v1/error"
require "peddler/types/vendor_transaction_status_v1/transaction_status"

module Peddler
  module Types
    module VendorTransactionStatusV1
      # The response schema for the getTransaction operation.
      GetTransactionResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransactionStatus] The response payload for the getTransaction operation.
        attribute?(:payload, TransactionStatus)
      end
    end
  end
end
