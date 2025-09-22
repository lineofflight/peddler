# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_sandbox_test_data_2021_10_28/test_order"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # A scenario test case response returned when the request is successful.
      Scenario = Structure.new do
        # @return [String] An identifier that identifies the type of scenario that user can use for testing.
        attribute(:scenario_id, String, from: "scenarioId")

        # @return [Array<TestOrder>] A list of orders that can be used by the caller to test each life cycle or
        # scenario.
        attribute(:orders, [TestOrder])
      end
    end
  end
end
