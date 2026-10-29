# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionPlans20260601
      # Response for the `listActionPlans` operation, containing the matching action plans and the total results count.
      ListActionPlansResponse = Structure.new do
        # @return [Array<ActionPlan>] The action plans matching the query. Steps are omitted by default.
        attribute(:action_plans, [ActionPlan], null: false, from: "actionPlans")

        # @return [Integer] The total number of action plans matching the query.
        attribute(:number_of_results, Integer, null: false, from: "numberOfResults")

        # @return [Pagination] Pagination metadata.
        attribute?(:pagination, Pagination)

        # @return [Hash] Search refinements for progressive filtering. Returned only when `includedData` contains
        #   `refinements`. This value is not yet supported.
        attribute?(:refinements, Hash)
      end
    end
  end
end
