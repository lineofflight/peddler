# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # Contains entities related to a plan.
      PlanReferences = Structure.new do
        # @return [Array<ActionItemReference>] Action items associated with this plan.
        attribute?(:action_items, [ActionItemReference], from: "actionItems")
      end
    end
  end
end
