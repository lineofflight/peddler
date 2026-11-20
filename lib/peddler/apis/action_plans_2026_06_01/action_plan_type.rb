# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionPlans20260601
      # The plan template this plan instantiates.
      ActionPlanType = Structure.new do
        # The plan template.
        attribute(:definition, PlanDefinitionRef, null: false)
      end
    end
  end
end
