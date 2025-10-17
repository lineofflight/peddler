# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Transportation details for the shipment.
      TransportationDetails = Structure.new do
        # @return [Array<TrackingDetails>] Tracking details for the shipment. If using SPD transportation, this can be
        #   for each case. If not using SPD transportation, this is a single tracking entry for the entire shipment.
        attribute(:tracking_details, [TrackingDetails], from: "trackingDetails")
      end
    end
  end
end
