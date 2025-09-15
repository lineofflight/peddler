# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_transactions_v1/error"

module Peddler
  module Types
    module VendorDirectFulfillmentTransactionsV1
      # The transaction status details.
      Transaction = Structure.new do
        # @return [String] The unique identifier sent in the 'transactionId' field in response to the post request of a
        # specific transaction.
        attribute(:transaction_id, String, from: "transactionId")

        # @return [String] Current processing status of the transaction.
        attribute(:status, String)

        # @return [Array<Error>] Error code and message for the failed transaction. Only available when transaction
        # status is 'Failure'.
        attribute(:errors, [Error])
      end
    end
  end
end
