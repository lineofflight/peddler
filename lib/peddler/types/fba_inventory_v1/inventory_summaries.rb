# frozen_string_literal: true

require "peddler/types/fba_inventory_v1/inventory_summary"

module Peddler
  module Types
    module FBAInventoryV1
      # A list of inventory summaries.
      class InventorySummaries < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| InventorySummary.parse(item) })
          end
        end
      end
    end
  end
end
