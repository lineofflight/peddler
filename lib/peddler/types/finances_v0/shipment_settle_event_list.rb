# frozen_string_literal: true

require "peddler/types/finances_v0/shipment_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of `ShipmentEvent` items.
      class ShipmentSettleEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| ShipmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
