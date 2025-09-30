# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_shipment"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of fulfillment shipment information.
      class FulfillmentShipmentList < Array
        class << self
          def parse(array)
            new(array.map { |item| FulfillmentShipment.parse(item) })
          end
        end
      end
    end
  end
end
