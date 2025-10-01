# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_v0/error"
require "peddler/types/fulfillment_inbound_v0/get_shipment_items_result"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getShipmentItems operation.
      GetShipmentItemsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [GetShipmentItemsResult] The payload for the getShipmentItems operation.
        attribute?(:payload, GetShipmentItemsResult)
      end
    end
  end
end
