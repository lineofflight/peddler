# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # A GUID assigned by Amazon to identify this transaction.
      TransactionReference = Structure.new do
        # @return [String] A GUID (Globally Unique Identifier) assigned by Amazon to uniquely identify the transaction.
        attribute?(:transaction_id, String, from: "transactionId")
      end
    end
  end
end
