# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # Response for the getActionPlan operation, containing the requested action plan.
      GetActionPlanResponse = Structure.new do
        # @return [ActionPlan] The action plan.
        attribute(:plan, ActionPlan, null: false)
      end
    end
  end
end
