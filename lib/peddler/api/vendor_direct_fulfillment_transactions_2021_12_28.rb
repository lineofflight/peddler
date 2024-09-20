# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Direct Fulfillment Transaction Status
    #
    # The Selling Partner API for Direct Fulfillment Transaction Status provides programmatic access to a direct
    # fulfillment vendor's transaction status.
    class VendorDirectFulfillmentTransactions20211228 < API
      # Returns the status of the transaction indicated by the specified `transactionId`.
      #
      # @param [String] transaction_id Previously returned in the response to the POST request of a specific
      #   transaction.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_transaction_status(transaction_id, rate_limit: 10.0)
        path = "/vendor/directFulfillment/transactions/2021-12-28/transactions/#{transaction_id}"

        meter(rate_limit).get(path)
      end
    end
  end
end
