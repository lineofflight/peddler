# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentSandboxTestData20211028
      # The set of test case data returned in response to the test data request.
      TestCaseData = Structure.new do
        # Set of use cases that describes the possible test scenarios.
        attribute?(:scenarios, [Scenario])
      end
    end
  end
end
