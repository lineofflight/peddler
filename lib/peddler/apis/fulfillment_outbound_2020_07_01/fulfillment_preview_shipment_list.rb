# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # An array of fulfillment preview shipment information.
      class FulfillmentPreviewShipmentList < Array
        class << self
          def parse(array)
            new(array.map { |item| FulfillmentPreviewShipment.parse(item) })
          end
        end
      end
    end
  end
end
