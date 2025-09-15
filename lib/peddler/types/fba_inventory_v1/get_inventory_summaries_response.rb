# frozen_string_literal: true

require "peddler/types/fba_inventory_v1/get_inventory_summaries_result"
require "peddler/types/fba_inventory_v1/pagination"
require "peddler/types/fba_inventory_v1/error"

module Peddler
  module Types
    module FBAInventoryV1
      # The Response schema.
      GetInventorySummariesResponse = Structure.new do
        # @return [GetInventorySummariesResult] The payload for the getInventorySummaries operation.
        attribute(:payload, GetInventorySummariesResult)

        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<Error>] One or more unexpected errors occurred during the getInventorySummaries operation.
        attribute(:errors, [Error])
      end
    end
  end
end
