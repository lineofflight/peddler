# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_v0/get_shipments_result"
require "peddler/types/fulfillment_inbound_v0/error"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getShipments operation.
      GetShipmentsResponse = Structure.new do
        # @return [GetShipmentsResult] The payload for the getShipments operation.
        attribute?(:payload, GetShipmentsResult)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
