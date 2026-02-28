# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentSandboxTestData20211028
      # The transaction details including the status. If the transaction was successful, also includes the requested
      # test order data.
      Transaction = Structure.new do
        # @return [String] The current processing status of the transaction.
        attribute(:status, String, null: false)

        # @return [String] The unique identifier returned in the response to the generateOrderScenarios request.
        attribute(:transaction_id, String, null: false, from: "transactionId")

        # @return [TestCaseData] Test case data for the transaction. Only available when the transaction status is
        #   SUCCESS.
        attribute?(:test_case_data, TestCaseData, from: "testCaseData")
      end
    end
  end
end
