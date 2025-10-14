# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The response of the `getShipments` operation.
      ShipmentsResponse = Structure.new do
        # @return [Pagination] How to manage multiple pages of data.
        attribute?(:pagination, Pagination)

        # @return [Array<Shipment>] A list of shipments.
        attribute?(:shipments, [Shipment])
      end
    end
  end
end
