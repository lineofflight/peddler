# frozen_string_literal: true

require "peddler/types/finances_v0/removal_shipment_item"

module Peddler
  module Types
    module FinancesV0
      # A list of information about removal shipment items.
      class RemovalShipmentItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| RemovalShipmentItem.parse(item) })
          end
        end
      end
    end
  end
end
