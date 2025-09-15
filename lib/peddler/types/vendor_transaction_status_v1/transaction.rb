# frozen_string_literal: true

require "peddler/types/vendor_transaction_status_v1/error"

module Peddler
  module Types
    module VendorTransactionStatusV1
      # The transaction status.
      Transaction = Structure.new do
        # @return [String] The unique identifier returned in the 'transactionId' field in response to the post request
        # of a specific transaction.
        attribute(:transaction_id, String, from: "transactionId")

        # @return [String] Current processing status of the transaction.
        attribute(:status, String)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
