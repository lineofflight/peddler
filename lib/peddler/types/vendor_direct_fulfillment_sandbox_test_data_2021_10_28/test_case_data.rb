# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_sandbox_test_data_2021_10_28/scenario"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # The set of test case data returned in response to the test data request.
      TestCaseData = Structure.new do
        # @return [Array<Scenario>] Set of use cases that describes the possible test scenarios.
        attribute?(:scenarios, [Scenario])
      end
    end
  end
end
