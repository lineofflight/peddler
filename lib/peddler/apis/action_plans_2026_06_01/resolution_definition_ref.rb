# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # The resolution definition on an action item.
      ResolutionDefinitionRef = Structure.new do
        # @return [String] The identifier of the resolution definition.
        attribute(:resolution_definition_id, String, null: false, from: "resolutionDefinitionId")
      end
    end
  end
end
