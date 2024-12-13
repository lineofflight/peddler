# frozen_string_literal: true

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
    class VendorDirectFulfillmentSandboxTestData20211028 < API
      # Submits a request to generate test order data for Vendor Direct Fulfillment API entities.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash] The request payload containing parameters for generating test order data scenarios.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def generate_order_scenarios(body, rate_limit: nil)
        path = "/vendor/directFulfillment/sandbox/2021-10-28/orders"

        post(path, body:)
      end

      # Returns the status of the transaction indicated by the specified transactionId. If the transaction was
      # successful, also returns the requested test order data.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param transaction_id [String] The transaction identifier returned in the response to the generateOrderScenarios
      #   operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_order_scenarios(transaction_id, rate_limit: nil)
        path = "/vendor/directFulfillment/sandbox/2021-10-28/transactions/#{transaction_id}"

        get(path)
      end
    end
  end
end
