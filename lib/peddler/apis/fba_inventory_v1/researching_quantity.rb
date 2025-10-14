# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
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
