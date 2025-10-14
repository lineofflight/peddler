# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `updateShipmentTrackingDetails` request.
      UpdateShipmentTrackingDetailsRequest = Structure.new do
        # @return [TrackingDetailsInput]
        attribute(:tracking_details, TrackingDetailsInput, from: "trackingDetails")
      end
    end
  end
end
