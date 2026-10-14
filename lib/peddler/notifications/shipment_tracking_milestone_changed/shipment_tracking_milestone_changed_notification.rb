# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ShipmentTrackingMilestoneChanged
      # The milestone change event data.
      ShipmentTrackingMilestoneChangedNotification = Structure.new do
        # @return [TrackingDetail] Current and historical tracking information for the shipment.
        attribute(:tracking_detail, TrackingDetail, null: false, from: "trackingDetail")
      end
    end
  end
end
