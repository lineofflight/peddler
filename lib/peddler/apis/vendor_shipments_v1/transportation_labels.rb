# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # The request schema for the GetShipmentLabels operation.
      TransportationLabels = Structure.new do
        # @return [Pagination]
        attribute?(:pagination, Pagination)

        # @return [Array<TransportLabel>] A list of one or more ShipmentLabels.
        attribute?(:transport_labels, [TransportLabel], from: "transportLabels")
      end
    end
  end
end
