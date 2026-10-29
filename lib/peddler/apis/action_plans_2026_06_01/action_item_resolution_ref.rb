# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # The resolution definition that satisfies an action item.
      ActionItemResolutionRef = Structure.new do
        # @return [ResolutionDefinitionRef] The resolution definition.
        attribute(:definition, ResolutionDefinitionRef, null: false)
      end
    end
  end
end
