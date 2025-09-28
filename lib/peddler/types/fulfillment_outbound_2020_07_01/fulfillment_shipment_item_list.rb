# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_shipment_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of fulfillment shipment item information.
      class FulfillmentShipmentItemList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| FulfillmentShipmentItem.parse(item) }) : new
          end
        end
      end
    end
  end
end
