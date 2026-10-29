# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Messaging20260420
      # The store-specific entry within an automation configuration. A seller can have multiple automation
      # configurations, and each configuration can contain entries for one or more Amazon stores. Each store entry
      # defines the automation response content (for example, the auto-response text) and the trigger conditions (for
      # example, specific buyer contact topics or ASINs) for that specific store.
      MarketplaceAutomation = Structure.new do
        # @return [AutomationDetails]
        attribute(:automation_details, AutomationDetails, null: false, from: "automationDetails")

        # @return [String] The [Amazon store identifier](https://developer-docs.amazon/sp-api/docs/marketplace-ids).
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [TriggerConditions]
        attribute(:trigger_conditions, TriggerConditions, null: false, from: "triggerConditions")
      end
    end
  end
end
