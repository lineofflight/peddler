# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # A reference from an action item to a specific step and its affected attributes.
      ActionItemStepReference = Structure.new do
        # @return [String] The step identifier (UUID) this action item relates to.
        attribute(:step_id, String, null: false, from: "stepId")

        # @return [Array<String>] The input or output attribute names on the step that this action item relates to.
        attribute?(:attribute_names, [String], from: "attributeNames")
      end
    end
  end
end
