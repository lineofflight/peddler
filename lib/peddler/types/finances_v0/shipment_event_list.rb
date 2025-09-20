# frozen_string_literal: true

require "peddler/types/finances_v0/shipment_event"

module Peddler
  module Types
    module FinancesV0
      # A list of shipment event information.
      class ShipmentEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ShipmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
