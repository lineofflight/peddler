# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # The action item's type and its display name.
      ActionItemTypeDefinition = Structure.new do
        # @return [LocalizedText] Localized display name of the action item type.
        attribute(:display_name, LocalizedText, null: false, from: "displayName")

        # @return [String] The semantic identifier of the action item type definition.
        attribute(:type_definition_id, String, null: false, from: "typeDefinitionId")
      end
    end
  end
end
