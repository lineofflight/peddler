# frozen_string_literal: true

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
    class VendorTransactionStatusV1 < API
      # Returns the status of the transaction that you specify.
      #
      # @param transaction_id [String] The GUID provided by Amazon in the 'transactionId' field in response to the post
      #   request of a specific transaction.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def get_transaction(transaction_id, rate_limit: 10.0, tries: 2)
        cannot_sandbox!

        path = "/vendor/transactions/v1/transactions/#{transaction_id}"

        meter(rate_limit, tries:).get(path)
      end
    end
  end
end
