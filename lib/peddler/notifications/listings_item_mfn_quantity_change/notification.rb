# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module ListingsItemMfnQuantityChange
      # To be delivered when the inventory quantity of a MFN Seller listing changes.
      Notification = Structure.new do
        # @return [Time] Timestamp of the event, formatted as ISO8601 date-time.
        attribute(:event_time, Time, from: "EventTime")

        # @return [Hash] The metadata of the notification.
        attribute(:notification_metadata, Hash, from: "NotificationMetadata")

        # @return [String] The type of the notification.
        attribute(:notification_type, String, from: "NotificationType")

        # @return [String] The version of the notification.
        attribute(:notification_version, String, from: "NotificationVersion")

        # @return [Payload] The details of this notification.
        attribute(:payload, Payload, from: "Payload")

        # @return [String] The version of the payload.
        attribute(:payload_version, String, from: "PayloadVersion")
      end
    end
  end
end
