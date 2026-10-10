# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module ListingsItemMfnQuantityChange
      # To be delivered when the inventory quantity of a MFN Seller listing changes.
      Notification = Structure.new do
        # Timestamp of the event, formatted as ISO8601 date-time.
        attribute(:event_time, Time, null: false, from: "EventTime")

        # The metadata of the notification.
        attribute(:notification_metadata, Hash, null: false, from: "NotificationMetadata")

        # The type of the notification.
        attribute(:notification_type, String, null: false, from: "NotificationType")

        # The version of the notification.
        attribute(:notification_version, String, null: false, from: "NotificationVersion")

        # The details of this notification.
        attribute(:payload, Payload, null: false, from: "Payload")

        # The version of the payload.
        attribute(:payload_version, String, null: false, from: "PayloadVersion")
      end
    end
  end
end
