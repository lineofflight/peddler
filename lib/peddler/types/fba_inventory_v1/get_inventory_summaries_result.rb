# frozen_string_literal: true

require "peddler/types/fba_inventory_v1/granularity"
require "peddler/types/fba_inventory_v1/inventory_summary"

module Peddler
  module Types
    module FBAInventoryV1
      # The payload schema for the getInventorySummaries operation.
      GetInventorySummariesResult = Structure.new do
        # @return [Granularity]
        attribute(:granularity, Granularity)

        # @return [Array<InventorySummary>]
        attribute(:inventory_summaries, [InventorySummary], from: "inventorySummaries")
      end
    end
  end
end
