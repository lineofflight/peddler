# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Vendor Direct Fulfillment Sandbox Test Data
    #
    # The Selling Partner API for Vendor Direct Fulfillment Sandbox Test Data provides programmatic access to vendor
    # direct fulfillment sandbox test data.
    class VendorDirectFulfillmentSandboxTestData20211028 < API
      # Submits a request to generate test order data for Vendor Direct Fulfillment API entities.
      #
      # @param [Hash] body The request payload that contain parameters to generate test order data scenarios.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def generate_order_scenarios(body, rate_limit: nil)
        path = "/vendor/directFulfillment/sandbox/2021-10-28/orders"

        post(path, body:)
      end

      # Retrieves the transaction status identified by the specified `transactionId`, and returns the requested test
      # order data if the transaction is successful.
      #
      # @param [String] transaction_id The transaction identifier returned in the response for the
      #   `generateOrderScenarios` operation.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_order_scenarios(transaction_id, rate_limit: nil)
        path = "/vendor/directFulfillment/sandbox/2021-10-28/transactions/#{transaction_id}"

        get(path)
      end
    end
  end
end
