# frozen_string_literal: true

require "peddler/types/finances_v0/removal_shipment_adjustment_event"

module Peddler
  module Types
    module FinancesV0
      # A comma-delimited list of Removal shipmentAdjustment details for FBA inventory.
      class RemovalShipmentAdjustmentEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| RemovalShipmentAdjustmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
