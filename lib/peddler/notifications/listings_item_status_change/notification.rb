# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module ListingsItemStatusChange
      # To be delivered when the status (e.g. buyability, discoverability) of a listings item changes.
      Notification = Structure.new do
        # @return [Time] Timestamp of the event, formatted as ISO8601 date-time.
        attribute(:event_time, Time, null: false, from: "EventTime")

        # @return [Hash] The metadata of the notification.
        attribute(:notification_metadata, Hash, null: false, from: "NotificationMetadata")

        # @return [String] The type of the notification.
        attribute(:notification_type, String, null: false, from: "NotificationType")

        # @return [String] The version of the notification.
        attribute(:notification_version, String, null: false, from: "NotificationVersion")

        # @return [Payload] The details of this notification.
        attribute(:payload, Payload, null: false, from: "Payload")

        # @return [String] The version of the payload.
        attribute(:payload_version, String, null: false, from: "PayloadVersion")
      end
    end
  end
end
