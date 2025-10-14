# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FBAInventoryV1
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
