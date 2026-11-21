# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Messaging20260420
      # The response for the `listAutomationConfigurations` operation.
      ListAutomationConfigsResponse = Structure.new do
        # A list of automation configurations.
        attribute(:automation_configurations, [AutomationConfiguration], null: false, from: "automationConfigurations")

        attribute?(:pagination, Pagination)
      end
    end
  end
end
