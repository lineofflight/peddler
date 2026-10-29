# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ActionItems20260601
      # The response schema for the `listActionItems` operation.
      ListActionItemsResponse = Structure.new do
        # @return [Array<ActionItem>] The action items matching the query, as full `ActionItem` objects.
        attribute(:action_items, [ActionItem], null: false, from: "actionItems")

        # @return [Pagination] Pagination details for the response.
        attribute?(:pagination, Pagination)

        # @return [Hash] Facet counts for progressive filtering across the full filtered result set. Only returned when
        #   `includedData` contains `refinements`.
        attribute?(:refinements, Hash)
      end
    end
  end
end
