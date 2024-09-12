# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Direct Fulfillment Transaction Status
    #
    # The Selling Partner API for Direct Fulfillment Transaction Status provides programmatic access to a direct
    # fulfillment vendor's transaction status.
    class VendorDirectFulfillmentTransactionsV1 < API
      # Returns the status of the transaction indicated by the specified `transactionId`.
      #
      # @param [String] transaction_id Previously returned in the response to the POST request of a specific
      #   transaction.
      # @return [Hash] The API response
      def get_transaction_status(transaction_id)
        path = "/vendor/directFulfillment/transactions/v1/transactions/#{transaction_id}"

        rate_limit(0.1).get(path)
      end
    end
  end
end
