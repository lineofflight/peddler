# frozen_string_literal: true

require "peddler/types/finances_v0/removal_shipment_adjustment_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A comma-delimited list of Removal shipmentAdjustment details for FBA inventory.
      class RemovalShipmentAdjustmentEventList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| RemovalShipmentAdjustmentEvent.parse(item) }) : new
          end
        end
      end
    end
  end
end
