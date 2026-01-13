# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Retail Procurement Transaction Status
    #
    # The Selling Partner API for Retail Procurement Transaction Status provides programmatic access to status
    # information on specific asynchronous POST transactions for vendors.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-transaction-status-api-model/vendorTransactionStatus.json
    class VendorTransactionStatusV1 < API
      # Returns the status of the transaction that you specify.
      #
      # @param transaction_id [String] The GUID provided by Amazon in the 'transactionId' field in response to the post
      #   request of a specific transaction.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_transaction(transaction_id, rate_limit: 10.0)
        cannot_sandbox!

        path = "/vendor/transactions/v1/transactions/#{percent_encode(transaction_id)}"
        parser = -> { GetTransactionResponse }
        get(path, rate_limit:, parser:)
      end
    end
  end
end
