# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # The request schema for the SubmitShipments operation.
      SubmitShipments = Structure.new do
        # A list of one or more shipments with underlying details.
        attribute?(:shipments, [Shipment])
      end
    end
  end
end
