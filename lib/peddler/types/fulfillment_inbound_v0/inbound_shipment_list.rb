# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_v0/inbound_shipment_info"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentInboundV0
      # A list of inbound shipment information.
      class InboundShipmentList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| InboundShipmentInfo.parse(item) }) : new
          end
        end
      end
    end
  end
end
