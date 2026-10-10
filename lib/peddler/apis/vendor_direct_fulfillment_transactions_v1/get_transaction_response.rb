# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentTransactionsV1
      # The response schema for the getTransactionStatus operation.
      GetTransactionResponse = Structure.new do
        attribute?(:errors, [Error])

        attribute?(:payload, TransactionStatus)
      end
    end
  end
end
