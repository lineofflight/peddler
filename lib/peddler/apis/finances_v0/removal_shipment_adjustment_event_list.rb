# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A comma-delimited list of `RemovalShipmentAdjustment` details for FBA inventory.
      class RemovalShipmentAdjustmentEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| RemovalShipmentAdjustmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
