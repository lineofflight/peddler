# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Retail Procurement Transaction Status
    #
    # The Selling Partner API for Retail Procurement Transaction Status provides programmatic access to status
    # information on specific asynchronous POST transactions for vendors.
    class VendorTransactionStatusV1 < API
      # Returns the status of the transaction that you specify.
      #
      # @param [String] transaction_id The GUID provided by Amazon in the 'transactionId' field in response to the post
      #   request of a specific transaction.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_transaction(transaction_id, rate_limit: 10.0)
        cannot_sandbox!

        path = "/vendor/transactions/v1/transactions/#{transaction_id}"

        meter(rate_limit).get(path)
      end
    end
  end
end
