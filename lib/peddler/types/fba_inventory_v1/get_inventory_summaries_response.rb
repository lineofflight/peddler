# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fba_inventory_v1/error"
require "peddler/types/fba_inventory_v1/pagination"
require "peddler/types/fba_inventory_v1/get_inventory_summaries_result"

module Peddler
  module Types
    module FBAInventoryV1
      # The Response schema.
      GetInventorySummariesResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the getInventorySummaries operation.
        attribute?(:errors, [Error])

        # @return [Pagination]
        attribute?(:pagination, Pagination)

        # @return [GetInventorySummariesResult] The payload for the getInventorySummaries operation.
        attribute?(:payload, GetInventorySummariesResult)
      end
    end
  end
end
