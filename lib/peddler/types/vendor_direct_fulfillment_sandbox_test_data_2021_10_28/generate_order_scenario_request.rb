# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_sandbox_test_data_2021_10_28/order_scenario_request"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # The request body for the generateOrderScenarios operation.
      GenerateOrderScenarioRequest = Structure.new do
        # @return [Array<OrderScenarioRequest>] The list of test orders requested as indicated by party identifiers.
        attribute?(:orders, [OrderScenarioRequest])
      end
    end
  end
end
