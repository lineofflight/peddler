# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_v0/error"
require "peddler/types/fulfillment_inbound_v0/get_shipments_result"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getShipments operation.
      GetShipmentsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [GetShipmentsResult] The payload for the getShipments operation.
        attribute?(:payload, GetShipmentsResult)
      end
    end
  end
end
