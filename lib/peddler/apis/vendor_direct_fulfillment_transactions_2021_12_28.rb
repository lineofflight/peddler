# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Transaction Status
    #
    # The Selling Partner API for Direct Fulfillment Transaction Status provides programmatic access to a direct
    # fulfillment vendor's transaction status.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-transactions-api-model/vendorDirectFulfillmentTransactions_2021-12-28.json
    class VendorDirectFulfillmentTransactions20211228 < API
      # Returns the status of the transaction indicated by the specified transactionId.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param transaction_id [String] Previously returned in the response to the POST request of a specific
      #   transaction.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_transaction_status(transaction_id, rate_limit: 10.0)
        path = "/vendor/directFulfillment/transactions/2021-12-28/transactions/#{percent_encode(transaction_id)}"
        parser = -> { TransactionStatus }
        get(path, rate_limit:, parser:)
      end
    end
  end
end
