# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Destination details of an inbound order based on the assigned region and DC for the order.
      DestinationDetails = Structure.new do
        # @return [Address] Destination address of the AWD facility where the shipment will be shipped to
        attribute?(:destination_address, Address, from: "destinationAddress")

        # @return [String] Assigned region where the order will be shipped. This can differ from what was passed as
        #   preference. AWD currently supports following region IDs: [us-west, us-east, us-southcentral, us-southeast]
        attribute?(:destination_region, String, from: "destinationRegion")

        # @return [String] Unique ID of the confirmed shipment being shipped to the assigned destination. This will be
        #   available only after an inbound order is confirmed and can be used to track the shipment.
        attribute?(:shipment_id, String, from: "shipmentId")
      end
    end
  end
end
