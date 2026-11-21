# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ShipmentTrackingMilestoneChanged
      # Metadata containing application, subscription, and notification identifiers.
      NotificationMetadata = Structure.new do
        # Unique identifier for the application receiving the notification.
        attribute(:application_id, String, null: false, from: "applicationId")

        # Unique identifier for the notification.
        attribute(:notification_id, String, null: false, from: "notificationId")

        # Timestamp when the notification was published to the queue, in RFC 3339 date-time format with UTC Z suffix.
        attribute(:publish_time, String, null: false, from: "publishTime")

        # Unique identifier for the notification subscription.
        attribute(:subscription_id, String, null: false, from: "subscriptionId")
      end
    end
  end
end
