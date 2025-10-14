# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # An array of fulfillment shipment item information.
      class FulfillmentShipmentItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| FulfillmentShipmentItem.parse(item) })
          end
        end
      end
    end
  end
end
