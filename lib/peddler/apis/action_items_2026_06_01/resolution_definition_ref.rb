# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # Details of a resolution, drawn from a catalog of resolution definitions that can be shared across action item
      # types.
      ResolutionDefinitionRef = Structure.new do
        # @return [String] Machine-readable identifier of the resolution definition (the change this resolution
        #   produces).
        attribute(:resolution_definition_id, String, null: false, from: "resolutionDefinitionId")

        # @return [LocalizedText] Localized display name of the resolution.
        attribute?(:display_name, LocalizedText, from: "displayName")
      end
    end
  end
end
