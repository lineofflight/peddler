# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # An end state that resolves the action item. The resolution itself is identified by
      # `definition.resolutionDefinitionId`. The type names the top-level mechanism for reaching that end state (for
      # example, `EXPAND_CROSS_STORE`), and each mechanism offers one or more pathways to accomplish it: the seller can
      # perform it themselves with the `url` and/or have Amazon automate it with `actionPlans`; a resolution always
      # offers at least one of these pathways. The optional description carries localized instructions for the
      # resolution as a whole; for text specific to one action plan, refer to `ActionPlanReference.description`.
      Resolution = Structure.new do
        # @return [ResolutionDefinitionRef]
        attribute(:definition, ResolutionDefinitionRef, null: false)

        # @return [String]
        attribute(:type, String, null: false)

        # @return [Array<ActionPlanReference>] Automated pathways for accomplishing this resolution. Each entry
        #   references an action plan template that Amazon can run to reach this resolution's end state.
        attribute?(:action_plans, [ActionPlanReference], from: "actionPlans")

        # @return [LocalizedText]
        attribute?(:description, LocalizedText)

        # @return [URI] Pathway for the selling partner to accomplish this resolution themselves: a URL to an existing
        #   experience. Optional; present when a manual pathway is available.
        attribute?(:url, URI)
      end
    end
  end
end
