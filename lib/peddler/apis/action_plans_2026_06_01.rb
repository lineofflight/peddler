# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Action Plans
    #
    # The Action Plans API allows you to create, configure, and execute action plans from pre-defined templates or
    # custom-built workflows.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/action-plans-api-model/actionPlans_2026-06-01.json
    module ActionPlans20260601
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "action_plans_2026_06_01.create_action_plan" => -> { GetActionPlanResponse },
        "action_plans_2026_06_01.get_action_plan" => -> { GetActionPlanResponse },
        "action_plans_2026_06_01.list_action_plans" => -> { ListActionPlansResponse },
      })
    end
  end
end
