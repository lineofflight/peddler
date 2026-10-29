# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # Request body for creating an action plan.
      CreateActionPlanRequest = Structure.new do
        # @return [String] The plan template to instantiate.
        attribute(:plan_template_id, String, null: false, from: "planTemplateId")

        # @return [ActionItemResolutionReference] The action item this plan addresses. When provided, inputs may be
        #   prepopulated from the action item context.
        attribute?(:action_item, ActionItemResolutionReference, from: "actionItem")

        # @return [Hash] Input values for the plan, keyed by name. Each entry is an object with a `value` property
        #   containing an array of strings.
        attribute?(:inputs, Hash)
      end
    end
  end
end
