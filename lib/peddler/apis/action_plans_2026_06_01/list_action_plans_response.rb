# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionPlans20260601
      # Response for the `listActionPlans` operation, containing the matching action plans and the total results count.
      ListActionPlansResponse = Structure.new do
        # The action plans matching the query. Steps are omitted by default.
        attribute(:action_plans, [ActionPlan], null: false, from: "actionPlans")

        # The total number of action plans matching the query.
        attribute(:number_of_results, Integer, null: false, from: "numberOfResults")

        # Pagination metadata.
        attribute?(:pagination, Pagination)

        # Search refinements for progressive filtering. Returned only when `includedData` contains `refinements`. This
        # value is not yet supported.
        attribute?(:refinements, Hash)
      end
    end
  end
end
