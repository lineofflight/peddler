# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # Combines one or more classifications with a reference to the action item's type definition.
      ActionItemType = Structure.new do
        # @return [Array<ActionItemTypeClassification>] One or more classifications for this action item. Known values:
        #   `ISSUE`, `TASK`, `RECOMMENDATION`.
        attribute(:classifications, Array, null: false)

        # @return [ActionItemTypeDefinition] The action item's type definition.
        attribute(:definition, ActionItemTypeDefinition, null: false)
      end
    end
  end
end
