# frozen_string_literal: true

require "peddler/types/finances_v0/removal_shipment_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of removal shipment event information.
      class RemovalShipmentEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| RemovalShipmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
