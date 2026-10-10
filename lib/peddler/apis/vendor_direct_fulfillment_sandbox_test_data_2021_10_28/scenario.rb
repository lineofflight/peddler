# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentSandboxTestData20211028
      # A scenario test case response returned when the request is successful.
      Scenario = Structure.new do
        # A list of orders that can be used by the caller to test each life cycle or scenario.
        attribute(:orders, [TestOrder], null: false)

        # An identifier that identifies the type of scenario that user can use for testing.
        attribute(:scenario_id, String, null: false, from: "scenarioId")
      end
    end
  end
end
