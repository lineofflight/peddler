# frozen_string_literal: true

require "peddler/types/external_fulfillment_shipments_2024_09_11/cancellation"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A list of cancellations for the given line item.
      #
      # **Note:** Currently, SmartConnect does not support partial cancellation of a shipment or its line items. This
      # list will contain a single value with all the cancellation details.
      class Cancellations < Array
        class << self
          def parse(array)
            new(array.map { |item| Cancellation.parse(item) })
          end
        end
      end
    end
  end
end
