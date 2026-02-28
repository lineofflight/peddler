# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentTransactions20211228
      # The transaction status details.
      Transaction = Structure.new do
        # @return [String] Current processing status of the transaction.
        attribute(:status, String, null: false)

        # @return [String] The unique identifier sent in the 'transactionId' field in response to the post request of a
        #   specific transaction.
        attribute(:transaction_id, String, null: false, from: "transactionId")

        # @return [ErrorList] Error code and message for the failed transaction. Only available when transaction status
        #   is 'Failure'.
        attribute?(:errors, ErrorList)
      end
    end
  end
end
