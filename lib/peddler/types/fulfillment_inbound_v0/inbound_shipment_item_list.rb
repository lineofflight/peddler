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
            new(array.map { |item| InboundShipmentItem.parse(item) })
          end
        end
      end
    end
  end
end
