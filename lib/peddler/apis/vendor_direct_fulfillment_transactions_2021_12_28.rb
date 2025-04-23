
require "peddler/api"


module Peddler
  class << self
    def vendor_direct_fulfillment_transactions_2021_12_28(...)
      APIs::VendorDirectFulfillmentTransactions20211228.new(...)
    end
  end

  module APIs
        # Selling Partner API for Direct Fulfillment Transaction Status
    #
        # The Selling Partner API for Direct Fulfillment Transaction Status provides programmatic access to a direct
    # fulfillment vendor's transaction status.
    class VendorDirectFulfillmentTransactions20211228 < API
      
      
              # Returns the status of the transaction indicated by the specified transactionId.
#
        # @note This operation can make a dynamic sandbox call.
        # @param transaction_id [String] Previously returned in the response to the POST request of a specific
      #   transaction.
        # @param rate_limit [Float] Requests per second
        # @return [Peddler::Response] The API response
      def get_transaction_status(transaction_id, rate_limit: 10.0)
path = "/vendor/directFulfillment/transactions/2021-12-28/transactions/#{transaction_id}"

  meter(rate_limit).get(path)

end

      
    end
  end
end
