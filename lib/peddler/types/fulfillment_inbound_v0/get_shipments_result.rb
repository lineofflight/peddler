# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_v0/inbound_shipment_info"

module Peddler
  module Types
    module FulfillmentInboundV0
      # Result for the get shipments operation
      GetShipmentsResult = Structure.new do
        # @return [Array<InboundShipmentInfo>] Information about your inbound shipments.
        attribute(:shipment_data, [InboundShipmentInfo], from: "ShipmentData")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        # response page.
        attribute(:next_token, String, from: "NextToken")
      end
    end
  end
end
