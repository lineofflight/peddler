# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Response containing the transaction ID.
      TransactionReference = Structure.new do
        # @return [String] GUID to identify this transaction. This value can be used with the Transaction Status API to
        # return the status of this transaction.
        attribute(:transaction_id, String, from: "transactionId")
      end
    end
  end
end
