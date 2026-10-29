# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # A reference to an action plan offered by a resolution. `actionPlanTemplateId` identifies the plan template;
      # `actionPlanId` identifies the created plan instance once one exists; `url` optionally deep-links to the action
      # plan experience for this template; `description` optionally carries localized text for this plan, distinguishing
      # it from other action plans offered on the same resolution.
      ActionPlanReference = Structure.new do
        # @return [String] The identifier of the plan template.
        attribute(:action_plan_template_id, String, null: false, from: "actionPlanTemplateId")

        # @return [String] The identifier of the created plan instance, when one exists. Optional; the backend may not
        #   populate it yet.
        attribute?(:action_plan_id, String, from: "actionPlanId")

        # @return [LocalizedText]
        attribute?(:description, LocalizedText)

        # @return [URI] Optional deep link to the action plan experience for this template.
        attribute?(:url, URI)
      end
    end
  end
end
