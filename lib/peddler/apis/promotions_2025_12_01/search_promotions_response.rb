# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # The response schema for the `searchPromotions` operation. **Note:** The `selectionDetails` field is not present
      # in the selection object within promotion summaries.
      SearchPromotionsResponse = Structure.new do
        # @return [Array<PromotionSummary>] A list of promotion summaries that matches the search criteria.
        attribute(:promotions, [PromotionSummary], null: false)

        # @return [Integer] The total number of promotions matching the search criteria, across all pages. This count
        #   remains consistent across paginated requests. **Note:** In rare cases, individual records cannot be returned
        #   and are omitted from the response. When this happens, a page may contain fewer items than expected, and the
        #   combined number of items across all pages may be less than `totalResults`. The request itself still
        #   completes successfully.
        attribute(:total_results, Integer, null: false, from: "totalResults")

        # @return [Pagination] Pagination information for navigating results.
        attribute?(:pagination, Pagination)
      end
    end
  end
end
