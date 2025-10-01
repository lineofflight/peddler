# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FBAInventoryV1
      # The misplaced or warehouse damaged inventory that is actively being confirmed at our fulfillment centers.
      ResearchingQuantityEntry = Structure.new do
        # @return [String] The duration of the research.
        attribute(:name, String)

        # @return [Integer] The number of units.
        attribute(:quantity, Integer)
      end
    end
  end
end
