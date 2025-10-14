# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The charges associated with the shipment.
      class Charges < Array
        class << self
          def parse(array)
            new(array.map { |item| Charge.parse(item) })
          end
        end
      end
    end
  end
end
