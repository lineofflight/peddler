# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ActionPlans20260601
      # A step instance within a plan.
      PlanStep = Structure.new do
        # @return [StepDefinitionRef] The step template this step instantiates.
        attribute(:definition, StepDefinitionRef, null: false)

        # @return [String] Whether this step completes automatically or requires manual seller action. Known values:
        #   `AUTOMATED`, `MANUAL`.
        attribute(:mode, String, null: false)

        # @return [String] Opaque unique identifier of this step within the plan (UUID).
        attribute(:step_id, String, null: false, from: "stepId")

        # @return [Time] When the step completed, in ISO 8601 format.
        attribute?(:completed_date, Time, from: "completedDate")

        # @return [Array<String>] Step identifiers (UUIDs) that must complete before this step runs.
        attribute?(:dependencies, [String])

        # @return [LocalizedText] Localized description of the step.
        attribute?(:description, LocalizedText)

        # @return [Hash] Resolved input values for this step, keyed by input name.
        attribute?(:inputs, Hash)

        # @return [Time] When the step was last updated, in ISO 8601 format.
        attribute?(:last_updated_date, Time, from: "lastUpdatedDate")

        # @return [Hash] Produced output values, keyed by output name.
        attribute?(:outputs, Hash)

        # @return [Time] When the step started execution, in ISO 8601 format.
        attribute?(:started_date, Time, from: "startedDate")

        # @return [Array<StepStatus>] The current state of the step. A step can take up to 7 days to complete. Known
        #   values: `NOT_STARTED`, `PENDING_DEPENDENCY`, `PENDING_SELLING_PARTNER`, `PROCESSING`, `COMPLETED`,
        #   `SKIPPED`, `SUCCEEDED`, `FAILED`.
        attribute?(:status, Array)
      end
    end
  end
end
