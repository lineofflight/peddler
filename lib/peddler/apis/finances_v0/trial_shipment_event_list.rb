# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of information about trial shipment financial events.
      class TrialShipmentEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| TrialShipmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
