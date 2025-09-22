# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/shipment"

module Peddler
  module Types
    module VendorShipmentsV1
      # The request schema for the SubmitShipments operation.
      SubmitShipments = Structure.new do
        # @return [Array<Shipment>] A list of one or more shipments with underlying details.
        attribute(:shipments, [Shipment])
      end
    end
  end
end
