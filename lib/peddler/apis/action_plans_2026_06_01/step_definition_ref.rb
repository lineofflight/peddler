# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # The step template and its input and output declarations.
      StepDefinitionRef = Structure.new do
        # @return [LocalizedText] Localized display name of the step definition.
        attribute(:display_name, LocalizedText, null: false, from: "displayName")

        # @return [String] The semantic identifier of the step definition.
        attribute(:step_definition_id, String, null: false, from: "stepDefinitionId")

        # @return [Hash] Input declarations for the step, keyed by name.
        attribute?(:inputs, Hash)

        # @return [Hash] Output declarations for the step, keyed by name.
        attribute?(:outputs, Hash)
      end
    end
  end
end
