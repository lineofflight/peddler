# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # The structured classification of an action item and a reference to the definition it instantiates.
      ActionItemType = Structure.new do
        # @return [Array<ActionItemTypeClassification>] One or more classifications for this action item. Known values:
        #   `ISSUE`, `RECOMMENDATION`, `TASK`.
        attribute(:classifications, Array, null: false)

        # @return [ActionItemTypeDefinition] A reference to the versioned action item definition this item is an
        #   instance of.
        attribute(:definition, ActionItemTypeDefinition, null: false)
      end
    end
  end
end
