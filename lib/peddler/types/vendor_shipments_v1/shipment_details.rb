# frozen_string_literal: true

require "peddler/types/vendor_shipments_v1/pagination"
require "peddler/types/vendor_shipments_v1/shipment"

module Peddler
  module Types
    module VendorShipmentsV1
      # The request schema for the GetShipmentDetails operation.
      ShipmentDetails = Structure.new do
        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<Shipment>] A list of one or more shipments with underlying details.
        attribute(:shipments, [Shipment])
      end
    end
  end
end
