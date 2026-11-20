# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ActionPlans20260601
      # An action plan instance.
      ActionPlan = Structure.new do
        # Unique identifier for this action plan (UUID, system-generated).
        attribute(:action_plan_id, String, null: false, from: "actionPlanId")

        # Current lifecycle state of the plan. Known values: `DRAFT`, `PENDING_SELLING_PARTNER`, `PROCESSING`, `DONE`,
        # `CANCELLED`, `PARTIAL`.
        attribute(:status, Array, null: false)

        # When the plan was accepted, in ISO 8601 format.
        attribute?(:accepted_date, Time, from: "acceptedDate")

        # Action items generated during plan creation or execution. Follows the same schema as the Action Items API.
        attribute?(:action_items, [ActionItem], from: "actionItems")

        # When the plan reached a terminal state, in ISO 8601 format.
        attribute?(:completed_date, Time, from: "completedDate")

        # When the plan was created, in ISO 8601 format.
        attribute?(:created_date, Time, from: "createdDate")

        # System-generated localized display name for the plan (read-only).
        attribute?(:display_name, LocalizedText, from: "displayName")

        # Input values for the plan, keyed by name. Omitted when empty.
        attribute?(:inputs, Hash)

        # When the plan was last updated, in ISO 8601 format.
        attribute?(:last_updated_date, Time, from: "lastUpdatedDate")

        # Entities related to this plan.
        attribute?(:references, PlanReferences)

        # When execution began, in ISO 8601 format.
        attribute?(:started_date, Time, from: "startedDate")

        # The plan's steps with their resolved input and output values. Included only when `includedData` contains
        # `steps`.
        attribute?(:steps, [PlanStep])

        # The plan template this plan instantiates.
        attribute?(:type, ActionPlanType)
      end
    end
  end
end
