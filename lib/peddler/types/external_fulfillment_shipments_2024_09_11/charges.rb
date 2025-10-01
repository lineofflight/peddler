# frozen_string_literal: true

require "peddler/types/external_fulfillment_shipments_2024_09_11/charge"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
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
