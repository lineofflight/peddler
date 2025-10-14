# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
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
