# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/api"

module Peddler
  class << self
    def vendor_transaction_status_v1(...)
      APIs::VendorTransactionStatusV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for Retail Procurement Transaction Status
    #
    # The Selling Partner API for Retail Procurement Transaction Status provides programmatic access to status
    # information on specific asynchronous POST transactions for vendors.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendorTransactionStatus.json
    class VendorTransactionStatusV1 < API
      # Returns the status of the transaction that you specify.
      #
      # @param transaction_id [String] The GUID provided by Amazon in the 'transactionId' field in response to the post
      #   request of a specific transaction.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_transaction(transaction_id, rate_limit: 10.0)
        path = "/vendor/transactions/v1/transactions/#{percent_encode(transaction_id)}"
        parser = Peddler::Types::VendorTransactionStatusV1::GetTransactionResponse if typed?
        meter(rate_limit).get(path, parser:)
      end

      private

      def load_types
        require "peddler/types/vendor_transaction_status_v1"
      end
    end
  end
end
