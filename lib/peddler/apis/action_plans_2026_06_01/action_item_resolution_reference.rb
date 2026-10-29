# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # Identifies the action item this plan resolves and the resolution it fulfills. Required when creating a plan from
      # an action item.
      ActionItemResolutionReference = Structure.new do
        # @return [String] The identifier of the action item this plan resolves.
        attribute(:action_item_id, String, null: false, from: "actionItemId")

        # @return [ActionItemResolutionRef] The resolution on the action item that this plan fulfills.
        attribute(:resolution, ActionItemResolutionRef, null: false)
      end
    end
  end
end
