# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Retail Procurement Transaction Status
    #
    # The Selling Partner API for Retail Procurement Transaction Status provides programmatic access to status
    # information on specific asynchronous POST transactions for vendors.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-transaction-status-api-model/vendorTransactionStatus.json
    module VendorTransactionStatusV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "vendor_transaction_status_v1.get_transaction" => -> { GetTransactionResponse },
      })
    end
  end
end
