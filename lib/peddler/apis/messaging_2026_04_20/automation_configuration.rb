# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Messaging20260420
      # Represents a seller's automation configuration for automated buyer-seller messaging. An automation configuration
      # defines rules for automatically responding to buyer inquiries, such as common questions about shipping, returns,
      # or product details. Each configuration has a type (for example, `AUTO_RESPONSE`), a status (`ACTIVE` or
      # `DEACTIVATED`), and one or more store-specific entries that contain the actual response content and trigger
      # conditions.
      AutomationConfiguration = Structure.new do
        # The seller-provided display name for the automation configuration.
        attribute(:automation_display_name, String, null: false, from: "automationDisplayName")

        # The unique identifier of the automation configuration.
        attribute(:automation_id, String, null: false, from: "automationId")

        # Known values: `ACTIVE`, `DEACTIVATED`.
        attribute(:automation_status, String, null: false, from: "automationStatus")

        # Known values: `AUTO_RESPONSE`.
        attribute(:automation_type, String, null: false, from: "automationType")

        # Known values: `AUTO_RESPONSE`.
        attribute?(:automation_sub_type, String, from: "automationSubType")

        # The date and time when the automation configuration was created, in ISO 8601 format.
        attribute?(:created_date_time, Time, from: "createdDateTime")

        # The version number of the automation configuration that is currently serving buyer messages. The version
        # number increases by one with each update.
        attribute?(:current_automation_version, Integer, from: "currentAutomationVersion")

        # The date and time when the automation configuration was last updated, in ISO 8601 format.
        attribute?(:last_updated_date_time, Time, from: "lastUpdatedDateTime")

        # The most recent version number of the automation configuration. Because updates take effect immediately, this
        # value always equals `currentAutomationVersion`.
        attribute?(:latest_automation_version, Integer, from: "latestAutomationVersion")

        # A list of store-specific automation entries. Each entry contains the response content and trigger conditions
        # for a specific Amazon store. Populated only for the `listAutomationConfigurations` operation when the
        # `includeMarketplaceAutomations` query parameter is set to `true`.
        attribute?(:marketplace_automations, [MarketplaceAutomation], from: "marketplaceAutomations")
      end
    end
  end
end
