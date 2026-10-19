# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ShipmentTrackingMilestoneChanged
      # The carrier information, including the tracking number and carrier code.
      CarrierTracking = Structure.new do
        # The tracking number assigned by the carrier.
        attribute(:tracking_number, String, null: false, from: "trackingNumber")

        # The carrier code associated with the carrier tracking number.
        attribute?(:carrier_code, String, from: "carrierCode")
      end
    end
  end
end
