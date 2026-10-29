# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # Contains an action item's references to steps and attributes.
      ActionItemReferences = Structure.new do
        # @return [Array<ActionItemStepReference>] The steps this action item relates to.
        attribute?(:steps, [ActionItemStepReference])
      end
    end
  end
end
