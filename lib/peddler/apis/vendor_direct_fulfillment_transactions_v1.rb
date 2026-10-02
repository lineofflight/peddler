# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Transaction Status
    #
    # The Selling Partner API for Direct Fulfillment Transaction Status provides programmatic access to a direct
    # fulfillment vendor's transaction status.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-transactions-api-model/vendorDirectFulfillmentTransactionsV1.json
    module VendorDirectFulfillmentTransactionsV1
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "vendor_direct_fulfillment_transactions_v1.get_transaction_status" => -> { GetTransactionResponse },
      }.freeze
    end
  end
end
