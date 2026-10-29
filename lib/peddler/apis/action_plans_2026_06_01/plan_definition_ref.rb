# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # The plan template and its input declarations.
      PlanDefinitionRef = Structure.new do
        # @return [LocalizedText] Localized display name of the plan template.
        attribute(:display_name, LocalizedText, null: false, from: "displayName")

        # @return [String] The semantic identifier of the plan template.
        attribute(:plan_definition_id, String, null: false, from: "planDefinitionId")

        # @return [Hash] Input declarations for the plan, keyed by input name.
        attribute?(:inputs, Hash)
      end
    end
  end
end
