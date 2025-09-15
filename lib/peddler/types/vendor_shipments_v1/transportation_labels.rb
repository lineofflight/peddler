# frozen_string_literal: true

require "peddler/types/vendor_shipments_v1/pagination"
require "peddler/types/vendor_shipments_v1/transport_label"

module Peddler
  module Types
    module VendorShipmentsV1
      # The request schema for the GetShipmentLabels operation.
      TransportationLabels = Structure.new do
        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<TransportLabel>] A list of one or more ShipmentLabels.
        attribute(:transport_labels, [TransportLabel], from: "transportLabels")
      end
    end
  end
end
