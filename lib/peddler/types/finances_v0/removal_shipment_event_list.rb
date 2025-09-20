# frozen_string_literal: true

require "peddler/types/finances_v0/removal_shipment_event"

module Peddler
  module Types
    module FinancesV0
      # A list of removal shipment event information.
      class RemovalShipmentEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| RemovalShipmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
