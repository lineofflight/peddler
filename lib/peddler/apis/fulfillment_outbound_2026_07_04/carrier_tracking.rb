# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Carrier tracking information for a package.
      CarrierTracking = Structure.new do
        # Identifies the carrier who delivers the shipment to the recipient.
        attribute(:carrier_code, String, null: false, from: "carrierCode")

        # The tracking number, if provided, can be used to obtain tracking and delivery information.
        attribute?(:tracking_number, String, from: "trackingNumber")

        # Represents the tracking URL where package tracking information is shown.
        attribute?(:tracking_url, String, from: "trackingUrl")
      end
    end
  end
end
