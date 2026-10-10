# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInboundV0
      # The response schema for the getShipmentItems operation.
      GetShipmentItemsResponse = Structure.new do
        attribute?(:errors, [Error])

        # The payload for the getShipmentItems operation.
        attribute?(:payload, GetShipmentItemsResult)
      end
    end
  end
end
