# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorTransactionStatusV1
      # The transaction status.
      Transaction = Structure.new do
        # @return [String] Current processing status of the transaction.
        attribute(:status, String, null: false)

        # @return [String] The unique identifier returned in the 'transactionId' field in response to the post request
        #   of a specific transaction.
        attribute(:transaction_id, String, null: false, from: "transactionId")

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
