# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_sandbox_test_data_2021_10_28/test_case_data"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # The transaction details including the status. If the transaction was successful, also includes the requested
      # test order data.
      Transaction = Structure.new do
        # @return [String] The unique identifier returned in the response to the generateOrderScenarios request.
        attribute(:transaction_id, String, from: "transactionId")

        # @return [String] The current processing status of the transaction.
        attribute(:status, String)

        # @return [TestCaseData] Test case data for the transaction. Only available when the transaction status is
        # SUCCESS.
        attribute?(:test_case_data, TestCaseData, from: "testCaseData")
      end
    end
  end
end
