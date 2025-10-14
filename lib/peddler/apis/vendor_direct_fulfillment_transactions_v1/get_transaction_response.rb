# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentTransactionsV1
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
