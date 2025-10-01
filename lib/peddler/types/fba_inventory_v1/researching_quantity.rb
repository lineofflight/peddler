# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fba_inventory_v1/researching_quantity_entry"

module Peddler
  module Types
    module FBAInventoryV1
      # The number of misplaced or warehouse damaged units that are actively being confirmed at our fulfillment centers.
      ResearchingQuantity = Structure.new do
        # @return [Array<ResearchingQuantityEntry>] A list of quantity details for items currently being researched.
        attribute?(:researching_quantity_breakdown, [ResearchingQuantityEntry], from: "researchingQuantityBreakdown")

        # @return [Integer] The total number of units currently being researched in Amazon's fulfillment network.
        attribute?(:total_researching_quantity, Integer, from: "totalResearchingQuantity")
      end
    end
  end
end
