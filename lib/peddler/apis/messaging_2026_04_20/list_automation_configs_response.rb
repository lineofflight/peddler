# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Messaging20260420
      # The response for the `listAutomationConfigurations` operation.
      ListAutomationConfigsResponse = Structure.new do
        # @return [Array<AutomationConfiguration>] A list of automation configurations.
        attribute(:automation_configurations, [AutomationConfiguration], null: false, from: "automationConfigurations")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
