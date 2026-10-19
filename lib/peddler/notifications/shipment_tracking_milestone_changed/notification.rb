# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ShipmentTrackingMilestoneChanged
      # The shipment tracking milestone change notification, with metadata and payload.
      Notification = Structure.new do
        # Timestamp when the tracking milestone change event occurred in RFC 3339 date-time format with UTC Z suffix.
        attribute(:event_time, String, null: false, from: "eventTime")

        # Metadata containing application and subscription information.
        attribute(:notification_metadata, NotificationMetadata, null: false, from: "notificationMetadata")

        # The notification type. Always `SHIPMENT_TRACKING_MILESTONE_CHANGED` for this schema.
        attribute(:notification_type, String, null: false, from: "notificationType")

        # The version of the notification format.
        attribute(:notification_version, String, null: false, from: "notificationVersion")

        # Contains the shipment tracking milestone change notification data.
        attribute(:payload, Payload, null: false)

        # The version of the payload schema format.
        attribute(:payload_version, String, null: false, from: "payloadVersion")
      end
    end
  end
end
