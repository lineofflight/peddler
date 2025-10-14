# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentSandboxTestData20211028
      # The request body for the generateOrderScenarios operation.
      GenerateOrderScenarioRequest = Structure.new do
        # @return [Array<OrderScenarioRequest>] The list of test orders requested as indicated by party identifiers.
        attribute?(:orders, [OrderScenarioRequest])
      end
    end
  end
end
