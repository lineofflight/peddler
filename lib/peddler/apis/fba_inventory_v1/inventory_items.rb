# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FBAInventoryV1
      # List of Inventory to be added
      class InventoryItems < Array
        class << self
          def parse(array)
            new(array.map { |item| InventoryItem.parse(item) })
          end
        end
      end
    end
  end
end
