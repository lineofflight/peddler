# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Shipment Status details.
      ShipmentStatusDetails = Structure.new do
        # @return [String] Current status of the shipment on whether it is picked up or scheduled.
        attribute?(:shipment_status, String, from: "shipmentStatus")

        # @return [Time] Date and time on last status update received for the shipment
        attribute?(:shipment_status_date, Time, from: "shipmentStatusDate")
      end
    end
  end
end
