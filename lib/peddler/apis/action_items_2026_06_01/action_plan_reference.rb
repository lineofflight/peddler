# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "uri"

module Peddler
  module APIs
    module ActionItems20260601
      # A reference to an action plan offered by a resolution. `actionPlanTemplateId` identifies the plan template;
      # `actionPlanId` identifies the created plan instance once one exists; `url` optionally deep-links to the action
      # plan experience for this template; `description` optionally carries localized text for this plan, distinguishing
      # it from other action plans offered on the same resolution.
      ActionPlanReference = Structure.new do
        # The identifier of the plan template.
        attribute(:action_plan_template_id, String, null: false, from: "actionPlanTemplateId")

        # The identifier of the created plan instance, when one exists. Optional; the backend may not populate it yet.
        attribute?(:action_plan_id, String, from: "actionPlanId")

        attribute?(:description, LocalizedText)

        # Optional deep link to the action plan experience for this template.
        attribute?(:url, URI)
      end
    end
  end
end
