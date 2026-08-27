# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Rules for catalog-based selections.
      SelectionRules = Structure.new do
        # @return [Array<Item>] Items to exclude from the catalog selection (maximum 100 items).
        attribute?(:excluded_items, [Item], from: "excludedItems")
      end
    end
  end
end
