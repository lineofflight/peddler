# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
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
