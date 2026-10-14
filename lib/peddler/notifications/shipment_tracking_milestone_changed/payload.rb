# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ShipmentTrackingMilestoneChanged
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [ShipmentTrackingMilestoneChangedNotification]
        attribute(:shipment_tracking_milestone_changed_notification, ShipmentTrackingMilestoneChangedNotification, null: false, from: "shipmentTrackingMilestoneChangedNotification")
      end
    end
  end
end
