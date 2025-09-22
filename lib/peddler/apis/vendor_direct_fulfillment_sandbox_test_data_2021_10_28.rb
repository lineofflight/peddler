# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/api"

module Peddler
  class << self
    def vendor_direct_fulfillment_sandbox_test_data_2021_10_28(...)
      APIs::VendorDirectFulfillmentSandboxTestData20211028.new(...)
    end
  end

  module APIs
    # Selling Partner API for Vendor Direct Fulfillment Sandbox Test Data
    #
    # The Selling Partner API for Vendor Direct Fulfillment Sandbox Test Data provides programmatic access to vendor
    # direct fulfillment sandbox test data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendorDirectFulfillmentSandboxData_2021-10-28.json
    class VendorDirectFulfillmentSandboxTestData20211028 < API
      # Submits a request to generate test order data for Vendor Direct Fulfillment API entities.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash] The request payload containing parameters for generating test order data scenarios.
      # @return [Peddler::Response] The API response
      def generate_order_scenarios(body)
        must_sandbox!

        path = "/vendor/directFulfillment/sandbox/2021-10-28/orders"
        parser = Peddler::Types::VendorDirectFulfillmentSandboxTestData20211028::TransactionReference if typed?
        post(path, body:, parser:)
      end

      # Returns the status of the transaction indicated by the specified transactionId. If the transaction was
      # successful, also returns the requested test order data.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param transaction_id [String] The transaction identifier returned in the response to the generateOrderScenarios
      #   operation.
      # @return [Peddler::Response] The API response
      def get_order_scenarios(transaction_id)
        must_sandbox!

        path = "/vendor/directFulfillment/sandbox/2021-10-28/transactions/#{percent_encode(transaction_id)}"
        parser = Peddler::Types::VendorDirectFulfillmentSandboxTestData20211028::TransactionStatus if typed?
        get(path, parser:)
      end

      private

      def load_types
        require "peddler/types/vendor_direct_fulfillment_sandbox_test_data_2021_10_28"
      end
    end
  end
end
