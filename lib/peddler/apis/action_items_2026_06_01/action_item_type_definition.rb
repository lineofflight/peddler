# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # A reference to the versioned action item definition, with a localized display name.
      ActionItemTypeDefinition = Structure.new do
        # @return [String] The semantic identifier of the action item definition. For example,
        #   `AFN_CROSS_STORE_EXPANSION`.
        attribute(:type_definition_id, String, null: false, from: "typeDefinitionId")

        # @return [LocalizedText] Localized display name of the definition.
        attribute?(:display_name, LocalizedText, from: "displayName")
      end
    end
  end
end
