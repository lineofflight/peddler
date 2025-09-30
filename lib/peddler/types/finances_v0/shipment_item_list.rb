# frozen_string_literal: true

require "peddler/types/finances_v0/shipment_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of shipment items.
      class ShipmentItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| ShipmentItem.parse(item) })
          end
        end
      end
    end
  end
end
