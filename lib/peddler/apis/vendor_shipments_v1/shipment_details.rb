# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # The request schema for the GetShipmentDetails operation.
      ShipmentDetails = Structure.new do
        attribute?(:pagination, Pagination)

        # A list of one or more shipments with underlying details.
        attribute?(:shipments, [Shipment])
      end
    end
  end
end
