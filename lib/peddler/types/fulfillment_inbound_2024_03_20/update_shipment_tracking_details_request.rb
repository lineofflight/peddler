# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/tracking_details_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `updateShipmentTrackingDetails` request.
      UpdateShipmentTrackingDetailsRequest = Structure.new do
        # @return [TrackingDetailsInput]
        attribute(:tracking_details, TrackingDetailsInput, from: "trackingDetails")
      end
    end
  end
end
