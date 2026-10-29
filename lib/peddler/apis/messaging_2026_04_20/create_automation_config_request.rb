# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Messaging20260420
      # The request body for creating a new automation configuration. A seller can have up to 10 automation
      # configurations, including deactivated configurations.
      CreateAutomationConfigRequest = Structure.new do
        # @return [String] A display name for the automation configuration. The name must be unique (case-insensitive)
        #   among the seller's automation configurations.
        attribute(:automation_display_name, String, null: false, from: "automationDisplayName")

        # @return [String] Known values: `AUTO_RESPONSE`.
        attribute(:automation_type, String, null: false, from: "automationType")

        # @return [Array<MarketplaceAutomation>] A list of store-specific automation entries. Each entry specifies the
        #   store, the response content, and the trigger conditions for that store.
        attribute(:marketplace_automations, [MarketplaceAutomation], null: false, from: "marketplaceAutomations")

        # @return [String] Known values: `AUTO_RESPONSE`.
        attribute?(:automation_sub_type, String, from: "automationSubType")
      end
    end
  end
end
