# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
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
