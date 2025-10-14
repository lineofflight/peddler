# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorTransactionStatusV1
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
