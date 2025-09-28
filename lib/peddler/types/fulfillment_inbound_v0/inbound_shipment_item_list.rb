# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_v0/inbound_shipment_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentInboundV0
      # A list of inbound shipment item information.
      class InboundShipmentItemList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| InboundShipmentItem.parse(item) }) : new
          end
        end
      end
    end
  end
end
