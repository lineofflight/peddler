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
      # @return [Hash] The API response
      def get_transaction(transaction_id)
        path = "/vendor/transactions/v1/transactions/#{transaction_id}"

        retriable(delay: proc { |i| 10.0 * i }).get(path)
      end
    end
  end
end
