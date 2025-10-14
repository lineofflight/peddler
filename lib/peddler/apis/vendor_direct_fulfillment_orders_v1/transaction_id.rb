# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrdersV1
      # Response containing the transaction ID.
      TransactionId = Structure.new do
        # @return [String] GUID assigned by Amazon to identify this transaction. This value can be used with the
        # Transaction Status API to return the status of this transaction.
        attribute?(:transaction_id, String, from: "transactionId")
      end
    end
  end
end
