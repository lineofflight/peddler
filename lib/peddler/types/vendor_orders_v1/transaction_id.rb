# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorOrdersV1
      # Response containing the transaction ID.
      TransactionId = Structure.new do
        # @return [String] GUID assigned by Amazon to identify this transaction. This value can be used with the
        # Transaction Status API to return the status of this transaction.
        attribute(:transaction_id, String, from: "transactionId")
      end
    end
  end
end
