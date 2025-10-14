# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentInboundV0
      # A list of inbound shipment item information.
      class InboundShipmentItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| InboundShipmentItem.parse(item) })
          end
        end
      end
    end
  end
end
