# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ActionPlans20260601
      # A step instance within a plan.
      PlanStep = Structure.new do
        # The step template this step instantiates.
        attribute(:definition, StepDefinitionRef, null: false)

        # Whether this step completes automatically or requires manual seller action. Known values: `AUTOMATED`,
        # `MANUAL`.
        attribute(:mode, String, null: false)

        # Opaque unique identifier of this step within the plan (UUID).
        attribute(:step_id, String, null: false, from: "stepId")

        # When the step completed, in ISO 8601 format.
        attribute?(:completed_date, Time, from: "completedDate")

        # Step identifiers (UUIDs) that must complete before this step runs.
        attribute?(:dependencies, [String])

        # Localized description of the step.
        attribute?(:description, LocalizedText)

        # Resolved input values for this step, keyed by input name.
        attribute?(:inputs, Hash)

        # When the step was last updated, in ISO 8601 format.
        attribute?(:last_updated_date, Time, from: "lastUpdatedDate")

        # Produced output values, keyed by output name.
        attribute?(:outputs, Hash)

        # When the step started execution, in ISO 8601 format.
        attribute?(:started_date, Time, from: "startedDate")

        # The current state of the step. A step can take up to 7 days to complete. Known values: `NOT_STARTED`,
        # `PENDING_DEPENDENCY`, `PENDING_SELLING_PARTNER`, `PROCESSING`, `COMPLETED`, `SKIPPED`, `SUCCEEDED`, `FAILED`.
        attribute?(:status, Array)
      end
    end
  end
end
