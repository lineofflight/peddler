# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInboundV0
      # The response schema for the getShipments operation.
      GetShipmentsResponse = Structure.new do
        attribute?(:errors, [Error])

        # The payload for the getShipments operation.
        attribute?(:payload, GetShipmentsResult)
      end
    end
  end
end
