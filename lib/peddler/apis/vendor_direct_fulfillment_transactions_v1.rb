# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def vendor_direct_fulfillment_transactions_v1(...)
      APIs::VendorDirectFulfillmentTransactionsV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for Direct Fulfillment Transaction Status
    #
    # The Selling Partner API for Direct Fulfillment Transaction Status provides programmatic access to a direct
    # fulfillment vendor's transaction status.
    class VendorDirectFulfillmentTransactionsV1 < API
      # Returns the status of the transaction indicated by the specified transactionId.
      #
      # @note This operation can make a static sandbox call.
      # @param transaction_id [String] Previously returned in the response to the POST request of a specific
      #   transaction.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_transaction_status(transaction_id, rate_limit: 10.0)
        path = "/vendor/directFulfillment/transactions/v1/transactions/#{URI.encode_uri_component(transaction_id)}"

        meter(rate_limit).get(path)
      end
    end
  end
end
