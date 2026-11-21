# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Messaging Automations
    #
    # The Selling Partner API for Messaging Automations allows sellers to programmatically manage automated buyer-seller
    # messaging configurations. An automation configuration defines rules for automatically responding to buyer messages
    # (for example, auto-responses to common questions about shipping, returns, or product details). A seller can create
    # multiple automation configurations, and each configuration can apply to one or more Amazon stores. Each
    # store-specific entry within a configuration contains the response content and the automation trigger conditions.
    # The `marketplaceIds` query parameter is required on all operations for store-scoped authorization.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/messaging-api-model/messaging_2026-04-20.json
    module Messaging20260420
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "messaging_2026_04_20.create_automation_configuration" => -> { AutomationConfiguration },
        "messaging_2026_04_20.get_automation_configuration" => -> { AutomationConfiguration },
        "messaging_2026_04_20.list_automation_configurations" => -> { ListAutomationConfigsResponse },
        "messaging_2026_04_20.update_automation_configuration" => -> { AutomationConfiguration },
      })
    end
  end
end
