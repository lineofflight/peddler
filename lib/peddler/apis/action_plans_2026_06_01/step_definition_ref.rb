# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionPlans20260601
      # The step template and its input and output declarations.
      StepDefinitionRef = Structure.new do
        # Localized display name of the step definition.
        attribute(:display_name, LocalizedText, null: false, from: "displayName")

        # The semantic identifier of the step definition.
        attribute(:step_definition_id, String, null: false, from: "stepDefinitionId")

        # Input declarations for the step, keyed by name.
        attribute?(:inputs, Hash)

        # Output declarations for the step, keyed by name.
        attribute?(:outputs, Hash)
      end
    end
  end
end
