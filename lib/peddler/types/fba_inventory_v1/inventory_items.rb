# frozen_string_literal: true

require "peddler/types/fba_inventory_v1/inventory_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FBAInventoryV1
      # List of Inventory to be added
      class InventoryItems < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| InventoryItem.parse(item) }) : new
          end
        end
      end
    end
  end
end
