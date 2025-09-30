# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_v0/get_shipment_items_result"
require "peddler/types/fulfillment_inbound_v0/error"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getShipmentItems operation.
      GetShipmentItemsResponse = Structure.new do
        # @return [GetShipmentItemsResult] The payload for the getShipmentItems operation.
        attribute?(:payload, GetShipmentItemsResult)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
