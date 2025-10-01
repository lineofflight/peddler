# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_sandbox_test_data_2021_10_28/transaction"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # The payload for the getOrderScenarios operation.
      TransactionStatus = Structure.new do
        # @return [Transaction]
        attribute?(:transaction_status, Transaction, from: "transactionStatus")
      end
    end
  end
end
