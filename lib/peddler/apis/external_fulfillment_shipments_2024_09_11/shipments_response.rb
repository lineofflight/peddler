# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # The response of the `getShipments` operation.
      ShipmentsResponse = Structure.new do
        # How to manage multiple pages of data.
        attribute?(:pagination, Pagination)

        # A list of shipments.
        attribute?(:shipments, [Shipment])
      end
    end
  end
end
