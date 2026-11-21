# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FBAInventoryV1
      # The misplaced or warehouse damaged inventory that is actively being confirmed at our fulfillment centers.
      ResearchingQuantityEntry = Structure.new do
        # The duration of the research. Known values: `researchingQuantityInShortTerm`, `researchingQuantityInMidTerm`,
        # `researchingQuantityInLongTerm`.
        attribute(:name, String, null: false)

        # The number of units.
        attribute(:quantity, Integer, null: false)
      end
    end
  end
end
