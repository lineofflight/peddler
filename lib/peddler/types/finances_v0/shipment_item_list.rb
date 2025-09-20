# frozen_string_literal: true

require "peddler/types/finances_v0/shipment_item"

module Peddler
  module Types
    module FinancesV0
      # A list of shipment items.
      class ShipmentItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ShipmentItem.parse(item) })
          end
        end
      end
    end
  end
end
