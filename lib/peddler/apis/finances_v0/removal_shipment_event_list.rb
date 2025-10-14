# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
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
