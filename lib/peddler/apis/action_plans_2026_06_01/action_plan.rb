# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ActionPlans20260601
      # An action plan instance.
      ActionPlan = Structure.new do
        # @return [String] Unique identifier for this action plan (UUID, system-generated).
        attribute(:action_plan_id, String, null: false, from: "actionPlanId")

        # @return [Array<PlanStatus>] Current lifecycle state of the plan. Known values: `DRAFT`,
        #   `PENDING_SELLING_PARTNER`, `PROCESSING`, `DONE`, `CANCELLED`, `PARTIAL`.
        attribute(:status, Array, null: false)

        # @return [Time] When the plan was accepted, in ISO 8601 format.
        attribute?(:accepted_date, Time, from: "acceptedDate")

        # @return [Array<ActionItem>] Action items generated during plan creation or execution. Follows the same schema
        #   as the Action Items API.
        attribute?(:action_items, [ActionItem], from: "actionItems")

        # @return [Time] When the plan reached a terminal state, in ISO 8601 format.
        attribute?(:completed_date, Time, from: "completedDate")

        # @return [Time] When the plan was created, in ISO 8601 format.
        attribute?(:created_date, Time, from: "createdDate")

        # @return [LocalizedText] System-generated localized display name for the plan (read-only).
        attribute?(:display_name, LocalizedText, from: "displayName")

        # @return [Hash] Input values for the plan, keyed by name. Omitted when empty.
        attribute?(:inputs, Hash)

        # @return [Time] When the plan was last updated, in ISO 8601 format.
        attribute?(:last_updated_date, Time, from: "lastUpdatedDate")

        # @return [PlanReferences] Entities related to this plan.
        attribute?(:references, PlanReferences)

        # @return [Time] When execution began, in ISO 8601 format.
        attribute?(:started_date, Time, from: "startedDate")

        # @return [Array<PlanStep>] The plan's steps with their resolved input and output values. Included only when
        #   `includedData` contains `steps`.
        attribute?(:steps, [PlanStep])

        # @return [ActionPlanType] The plan template this plan instantiates.
        attribute?(:type, ActionPlanType)
      end
    end
  end
end
