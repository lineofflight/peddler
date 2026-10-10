# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Transaction Status
    #
    # The Selling Partner API for Direct Fulfillment Transaction Status provides programmatic access to a direct
    # fulfillment vendor's transaction status.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-transactions-api-model/vendorDirectFulfillmentTransactions_2021-12-28.json
    module VendorDirectFulfillmentTransactions20211228
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "vendor_direct_fulfillment_transactions_2021_12_28.get_transaction_status" => -> { TransactionStatus },
      })
    end
  end
end
