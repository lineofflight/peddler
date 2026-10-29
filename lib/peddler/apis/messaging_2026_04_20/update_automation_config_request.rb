# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Messaging20260420
      # The request body for updating an existing automation configuration.
      UpdateAutomationConfigRequest = Structure.new do
        # @return [String] An updated display name for the automation configuration. To keep the current name, provide
        #   the existing value.
        attribute(:automation_display_name, String, null: false, from: "automationDisplayName")

        # @return [String] Known values: `ACTIVE`, `DEACTIVATED`.
        attribute(:automation_status, String, null: false, from: "automationStatus")

        # @return [Array<MarketplaceAutomation>] The complete list of store-specific automation entries for the
        #   configuration. This list replaces all existing entries; any store you omit is removed from the
        #   configuration.
        attribute(:marketplace_automations, [MarketplaceAutomation], null: false, from: "marketplaceAutomations")
      end
    end
  end
end
