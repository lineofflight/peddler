# frozen_string_literal: true

require "peddler/types/fba_inventory_v1/inventory_summary"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FBAInventoryV1
      # A list of inventory summaries.
      class InventorySummaries < Array
        class << self
          def parse(array)
            new(array.map { |item| InventorySummary.parse(item) })
          end
        end
      end
    end
  end
end
