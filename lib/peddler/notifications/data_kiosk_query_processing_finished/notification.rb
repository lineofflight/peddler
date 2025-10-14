# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module DataKioskQueryProcessingFinished
      # This notification is delivered when a Data Kiosk query finishes processing.
      Notification = Structure.new do
        # @return [String] The time the notification was sent in ISO 8601 format.
        attribute(:event_time, String, from: "eventTime")

        # @return [Hash] The notification's metadata.
        attribute(:notification_metadata, Hash, from: "notificationMetadata")

        # @return [String] The notification type.
        attribute(:notification_type, String, from: "notificationType")

        # @return [String] The notification version.
        attribute(:notification_version, String, from: "notificationVersion")

        # @return [Payload] The Data Kiosk query processing notification payload.
        attribute(:payload, Payload)

        # @return [String] The payload version of the notification.
        attribute(:payload_version, String, from: "payloadVersion")
      end
    end
  end
end
