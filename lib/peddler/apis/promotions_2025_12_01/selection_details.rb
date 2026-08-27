# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Detailed selection information including items, rules, issues, and pagination.
      SelectionDetails = Structure.new do
        # @return [Array<ItemIssue>] Item-level validation issues for items in this selection. Only present when
        #   `ISSUES` is included in the `includedData` query parameter.
        attribute?(:issues, [ItemIssue])

        # @return [Array<Item>] List of specific items to include. Only valid when `type` is `ITEMS` (maximum 100
        #   items).
        attribute?(:items, [Item])

        # @return [Pagination] Pagination metadata for navigating through pages of selection items.
        attribute?(:pagination, Pagination)

        # @return [SelectionRules] Rule configuration for catalog-based selections. Only valid when `type` is `CATALOG`.
        attribute?(:rules, SelectionRules)
      end
    end
  end
end
