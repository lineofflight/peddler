# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # Shipment Status details.
      ShipmentStatusDetails = Structure.new do
        # @return [String] Current status of the shipment on whether it is picked up or scheduled.
        attribute?(:shipment_status, String, from: "shipmentStatus")

        # @return [String] Date and time on last status update received for the shipment
        attribute?(:shipment_status_date, String, from: "shipmentStatusDate")
      end
    end
  end
end
