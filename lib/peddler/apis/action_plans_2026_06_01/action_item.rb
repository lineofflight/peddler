# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # An issue or required action on a specific step surfaced during plan creation or execution.
      ActionItem = Structure.new do
        # @return [LocalizedText] Localized description of the action item.
        attribute(:description, LocalizedText, null: false)

        # @return [ActionItemType] The classification of this action item and a reference to its type definition.
        attribute(:type, ActionItemType, null: false)

        # @return [ActionItemReferences] The steps and attributes within the plan that this action item relates to.
        attribute?(:references, ActionItemReferences)
      end
    end
  end
end
