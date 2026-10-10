# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      # The root schema comprises the entire JSON document.
      Notification = Structure.new do
        # Timestamp of the event, formatted as ISO 8601 date-time.
        attribute(:event_time, String, null: false, from: "EventTime")

        # Metadata about the notification.
        attribute(:notification_metadata, Hash, null: false, from: "NotificationMetadata")

        # The type of notification being sent.
        attribute(:notification_type, String, null: false, from: "NotificationType")

        # The version of the notification.
        attribute(:notification_version, String, null: false, from: "NotificationVersion")

        # Contains the fulfillment order status notification data.
        attribute(:payload, Payload, null: false, from: "Payload")

        # The version of the payload format.
        attribute(:payload_version, String, null: false, from: "PayloadVersion")
      end
    end
  end
end
