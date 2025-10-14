# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
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
